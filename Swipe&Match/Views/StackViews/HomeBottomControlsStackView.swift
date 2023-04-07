//
//  HomeBottomControlsStackView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    let refreshButton = createButton(image: BottomImages.refresh!)
    let dismissButton = createButton(image: BottomImages.dismiss!)
    let superLikeButton = createButton(image: BottomImages.superLike!)
    let likeButton = createButton(image: BottomImages.like!)
    let boostButton = createButton(image: BottomImages.boost!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    private func configureView() {
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dismissButton, superLikeButton, likeButton, boostButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
