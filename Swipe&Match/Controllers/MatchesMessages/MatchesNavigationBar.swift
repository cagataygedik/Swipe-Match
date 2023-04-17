//
//  MatchesNavigationBar.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 17.04.2023.
//

import LBTATools

class MatchesNavigationBar: UIView {
    
    let backButton = UIButton(image: Buttons.fire!, tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
                
        let iconImageView = UIImageView(image: Buttons.messagesChatIcon, contentMode: .scaleAspectFit)
        iconImageView.tintColor = Color.messages.navBarColor
        
        let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: Color.messages.navBarColor, textAlignment: .center)
        
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        stack(iconImageView.withHeight(44), hstack(messageLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
