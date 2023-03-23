//
//  ViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 23.03.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grayView = UIView()
        grayView.backgroundColor = .gray
        
        let darkGreyView = UIView()
        darkGreyView.backgroundColor = .darkGray
        
        let blackView = UIView()
        blackView.backgroundColor = .black
        
        let topStackView = UIStackView(arrangedSubviews: [grayView, darkGreyView, blackView])
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        stackView.fillSuperview()
    }
}

