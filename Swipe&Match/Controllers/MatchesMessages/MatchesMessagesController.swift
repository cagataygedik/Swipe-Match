//
//  MatchesMessagesController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 17.04.2023.
//

import LBTATools

class MatchesMessagesController: UICollectionViewController {
    
    let customNavigationBar: UIView = {
        let navigationBar = UIView(backgroundColor: .white)
        navigationBar.setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let iconImageView = UIImageView(image: Buttons.messagesChatIcon, contentMode: .scaleAspectFit)
        iconImageView.tintColor = Color.messages.navBarColor
        
        let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: Color.messages.navBarColor, textAlignment: .center)
        
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)
        
        navigationBar.stack(iconImageView.withHeight(44), navigationBar.hstack(messageLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavigationBar)
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
}
