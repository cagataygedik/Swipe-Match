//
//  Constants.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 24.03.2023.
//

import Foundation
import UIKit

enum Buttons {
    static let profile = UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal)
    static let fire = UIImage(named: "app_icon")?.withRenderingMode(.alwaysOriginal)
    static let chat = UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal)

    static let info = UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal)
    static let dismissDown = UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal)

    static let refresh = UIImage(named: "refresh_circle")?.withRenderingMode(.alwaysOriginal)
    static let dismiss = UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal)
    static let superLike = UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal)
    static let like = UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal)
    static let boost = UIImage(named: "boost_circle")?.withRenderingMode(.alwaysOriginal)
}

enum Placeholder {
    static let fullName = "Enter full name"
    static let email = "Enter e-mail"
    static let password = "Enter password"
    static let name = "Enter your name"
    static let age = "Enter your age"
    static let bio = "Enter your bio"
    static let profession = "Enter your profession"
    static let selectPhoto = "Select a photo"
    static let image = UIImage(named: "photo_placeholder")?.withRenderingMode(.alwaysOriginal)
}

enum Color {
    static let top = UIColor(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1.0)
    static let bottom = UIColor(red: 0.8980392157, green: 0.0, blue: 0.4470588235, alpha: 1.0)
    static let button = UIColor(red: 0.8235294118, green: 0.0, blue: 0.3254901961, alpha: 1.0)
    static let tableView = UIColor(white: 0.95, alpha: 1)
    static let left = UIColor(red: 1.0, green: 0.01176470588, blue: 0.4470588235, alpha: 1.0)
    static let right = UIColor(red: 1.0, green: 0.3921568627, blue: 0.3176470588, alpha: 1.0)
}

enum Title {
    static let photo = "Select a photo"
    static let register = "Register"
    static let goToLogin = "Go to Login"
    static let login = "Login"
    static let goToRegister = "Go to Register"
}

enum NavigationItemText {
    static let settings = "Settings"
    static let cancel = "Cancel"
    static let save = "Save"
    static let logout = "Logout"
}

enum HeaderText {
    static let name = "Name"
    static let profession = "Profession"
    static let age = "Age"
    static let bio = "Bio"
}
