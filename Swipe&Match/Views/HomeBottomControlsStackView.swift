//
//  HomeBottomControlsStackView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    let refreshButton = UIButton(type: .system)
    let dismissButton = UIButton(type: .system)
    let superLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureRefreshButton()
        configureDismissButton()
        configureSuperLikeButton()
        configureLikeButton()
        configureBoostButton()
    }
    
    private func configureView() {
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureRefreshButton() {
        addArrangedSubview(refreshButton)
        refreshButton.setImage(BottomImages.refresh?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func configureDismissButton() {
        addArrangedSubview(dismissButton)
        dismissButton.setImage(BottomImages.dismiss?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func configureSuperLikeButton() {
        addArrangedSubview(superLikeButton)
        superLikeButton.setImage(BottomImages.superLike?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func configureLikeButton() {
        addArrangedSubview(likeButton)
        likeButton.setImage(BottomImages.like?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func configureBoostButton() {
        addArrangedSubview(boostButton)
        boostButton.setImage(BottomImages.boost?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
