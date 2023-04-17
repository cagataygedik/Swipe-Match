//
//  ViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeViewController: UIViewController, SettingsTableViewControllerDelegate, LoginViewControllerDelegate, CardViewDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    let hud = JGProgressHUD(style: .light)
    
    var cardViewModels = [CardViewModel]()
    var lastFetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupFirestoreUserCards()
        configureBottomStackView()
        configureTopStackView()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationViewController = RegistrationViewController()
            registrationViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: registrationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate var user: User?
    
    private func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                self.hud.dismiss()
                return
            }
            self.hud.dismiss()
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.fetchSwipes()
            //self.fetchUsersFromFirestore()
        }
    }
    
    private func configureBottomStackView() {
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomStackView.dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    var swipes = [String: Int]()
    
    private func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot,err) in
            if let err = err {
                print("Failed to fetch swipes", err)
            }
            print("swipes", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc private func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUsersFromFirestore()
    }
    
    
    private func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { (snapshot,err) in
            hud.dismiss()
            if let err = err {
                print("Failed", err)
                return
            }
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDismiss() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    private func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot,err) in
            if let err = err {
                print("failed to get document", err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData)
                { (err) in
                    if let err = err {
                        print("failed to save swipe data", err)
                    }
                    print("successfully updated")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("failed to save swipe data", err)
                        return
                    }
                    print("successfully saved swipe")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    private func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print("failed to fetch data", err)
                return
            }
            guard let data = snapshot?.data() else { return }
            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    private func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    private func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    private func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsViewController = UserDetailsViewController()
        userDetailsViewController.modalPresentationStyle = .fullScreen
        userDetailsViewController.cardViewModel = cardViewModel
        present(userDetailsViewController, animated: true)
    }
    
    private func configureTopStackView() {
        topStackView.profileButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.chatButton.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
    }
    
    @objc private func handleChat() {
        let vc = MatchesMessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleSettings() {
        let settingsTableViewController = SettingsTableViewController()
        settingsTableViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingsTableViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    fileprivate func configureView() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        let allStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        view.addSubview(allStackView)
        allStackView.axis = .vertical
        allStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        allStackView.isLayoutMarginsRelativeArrangement = true
        allStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        allStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
    }
}
