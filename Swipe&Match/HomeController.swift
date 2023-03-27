//
//  ViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    let users = [
        User(name: "Kelly", age: 23, profession: "Music and DJ", imageName: "lady5c"),
        User(name: "Jane", age: 25, profession: "Teacher", imageName: "lady4c")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupDummyCards()
    }
    
    fileprivate func configureView() {
        let allStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        view.addSubview(allStackView)
        allStackView.axis = .vertical
        allStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        allStackView.isLayoutMarginsRelativeArrangement = true
        allStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        allStackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupDummyCards() {
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: user.imageName)
            cardView.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
            cardView.informationLabel.attributedText = attributedText
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

