//
//  ViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupDummyCards()
        configureTopStackView()
        fetchUsersFromFirestore()
    }
    
    private func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot,err) in
            if let err = err {
                print("Failed", err)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupDummyCards()
        }
    }
    
    private func configureTopStackView() {
        topStackView.profileButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    }
    
    @objc private func handleSettings() {
        let registrationViewController = RegistrationViewController()
        registrationViewController.modalPresentationStyle = .fullScreen
        present(registrationViewController, animated: true)
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
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

