//
//  ViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeViewController: UIViewController, SettingsTableViewControllerDelegate, LoginViewControllerDelegate {
    
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
        configureTopStackView()
        fetchCurrentUser()
        //fetchUsersFromFirestore()
        //configureBottomStackView()
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
            self.fetchUsersFromFirestore()
        }
    }
    
    private func configureBottomStackView() {
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    @objc private func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    private func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot,err) in
            hud.dismiss()
            if let err = err {
                print("Failed", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    private func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    private func configureTopStackView() {
        topStackView.profileButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
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

