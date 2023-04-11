//
//  RegisterButton.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 3.04.2023.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        isEnabled = false
        backgroundColor = .lightGray
        setTitleColor(.white, for: .disabled)
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        layer.cornerRadius = 5
    }
}
