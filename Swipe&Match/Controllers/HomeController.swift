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
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
        User(name: "Kelly", age: 23, profession: "Music and DJ", imageName: "lady5c"),
        User(name: "Jane", age: 25, profession: "Teacher", imageName: "lady4c"),
        Advertiser(title: "Slide out menu", brandName: "let's build that app", posterPhotoName: "slide_out_menu_poster")
        ] as [ProducesCardViewModel]
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
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
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

