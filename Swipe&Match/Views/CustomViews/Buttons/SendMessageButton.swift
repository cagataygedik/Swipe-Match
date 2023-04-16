//
//  SendMessageButton.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 16.04.2023.
//

import UIKit

class SendMessageButton: UIButton {
    
    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = Color.left
        let rightColor = Color.right
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
}
