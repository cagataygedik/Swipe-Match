//
//  CardViewModel.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 28.03.2023.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageUrls: [String]
    let attributedString: NSMutableAttributedString
    let textAlignment: NSTextAlignment

    var imageIndexObserver: ((Int, String?) -> ())?
    
    init(imageNames: [String], attributedString: NSMutableAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex ,imageUrl)
        }
    }
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
