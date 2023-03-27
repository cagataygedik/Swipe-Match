//
//  CardView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 25.03.2023.
//

import UIKit

class CardView: UIView {
    
    let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "lady5c"))
    let informationLabel = UILabel()
    
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureInformationLabel()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func configureInformationLabel() {
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChangedPanGesture(gesture)
        case .ended:
            handleEndedPanGesture(gesture)
        default:
            break
        }
    }
    
    fileprivate func handleChangedPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEndedPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
