//
//  CustomTextField.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 31.03.2023.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, keyboardType: UIKeyboardType) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        layer.cornerRadius = 5
        autocorrectionType = .no
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
}
