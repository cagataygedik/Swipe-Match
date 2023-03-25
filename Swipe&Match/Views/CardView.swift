//
//  CardView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 25.03.2023.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "lady5c"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
    }
    
    private func configureView() {
        addSubview(imageView)
        imageView.fillSuperview()
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChangedPanGesture(gesture)
        case .ended:
            handleEndedPanGesture()
        default:
            break
        }
    }
    
    fileprivate func handleChangedPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEndedPanGesture() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.transform = .identity
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
