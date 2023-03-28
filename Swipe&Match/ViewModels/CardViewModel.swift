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

struct CardViewModel {
    let imageName: String
    let attributedString: NSMutableAttributedString
    let textAlignment: NSTextAlignment
}
