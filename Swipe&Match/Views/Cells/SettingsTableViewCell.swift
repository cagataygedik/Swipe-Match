//
//  SettingsTableViewCell.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 7.04.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    class SettingsTextField: UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
    }
    
    let textField = SettingsTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    private func configure() {
        textField.placeholder = Placeholder.name
        contentView.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
