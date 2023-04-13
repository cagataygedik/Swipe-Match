//
//  TopNavigationStackView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let profileButton = UIButton(type: .system)
    let fireButton = UIButton(type: .system)
    let chatButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureProfileButton()
        configureFireButtom()
        configureChatButton()
    }
    
    private func configureView() {
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func configureProfileButton() {
        addArrangedSubview(profileButton)
        profileButton.setImage(TopImages.profile, for: .normal)
    }
    
    private func configureFireButtom() {
        addArrangedSubview(fireButton)
        fireButton.setImage(TopImages.fire, for: .normal)
        fireButton.contentMode = .scaleAspectFit
    }
    
    private func configureChatButton() {
        addArrangedSubview(chatButton)
        chatButton.setImage(TopImages.chat, for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
