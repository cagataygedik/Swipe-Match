//
//  SelectPhotoButton.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 3.04.2023.
//

import UIKit

class RegisterSelectPhotoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        setTitle(Title.photo, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        heightAnchor.constraint(equalToConstant: 275).isActive = true
        layer.cornerRadius = 16
        imageView?.contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
