//
//  Constants.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 24.03.2023.
//

import Foundation
import UIKit

enum TopImages {
    static let profile = UIImage(named: "top_left_profile")
    static let fire = UIImage(named: "app_icon")
    static let chat = UIImage(named: "top_right_messages")
}

enum BottomImages {
    static let refresh = UIImage(named: "refresh_circle")
    static let dismiss = UIImage(named: "dismiss_circle")
    static let superLike = UIImage(named: "super_like_circle")
    static let like = UIImage(named: "like_circle")
    static let boost = UIImage(named: "boost_circle")
}

enum Placeholder {
    static let fullName = "Enter full name"
    static let email = "Enter e-mail"
    static let password = "Enter password"
}

enum Color {
    static let top = UIColor(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1.0)
    static let bottom = UIColor(red: 0.8980392157, green: 0.0, blue: 0.4470588235, alpha: 1.0)
    static let button = UIColor(red: 0.8235294118, green: 0.0, blue: 0.3254901961, alpha: 1.0)
}

enum Title {
    static let photo = "Select a photo"
    static let register = "Register"
}
