//
//  CardView.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 25.03.2023.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageUrls.first ?? ""
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url, placeholderImage: Placeholder.image, options: .continueInBackground)
            }
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = .darkGray
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "lady5c"))
    let informationLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    let barsStackView = UIStackView()
    let moreInfoButton = UIButton(type: .system)
    
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        setupBarsStackView()
        setupGradientLayer()
        configureInformationLabel()
        handleGestures()
        configureMoreInfoButton()
    }
    
    private func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url, placeholderImage: Placeholder.image, options: .continueInBackground)
            }
            
            self?.barsStackView.arrangedSubviews.forEach { (view) in
                //deselected color
                view.backgroundColor = .darkGray
            }
            //selected color
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    private func handleGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func configureInformationLabel() {
        addSubview(informationLabel)
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }
    
    private func configureMoreInfoButton() {
        addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.setImage(Buttons.info, for: .normal)
        moreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    @objc private func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    @objc fileprivate func handleTapGesture(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            handleBeganPanGesture(gesture)
        case .changed:
            handleChangedPanGesture(gesture)
        case .ended:
            handleEndedPanGesture(gesture)
        default:
            break
        }
    }
    
    fileprivate func handleBeganPanGesture(_ gesture: UIPanGestureRecognizer) {
        superview?.subviews.forEach({ (subview) in
            subview.layer.removeAllAnimations()
        })
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
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
