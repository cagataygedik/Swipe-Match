//
//  PhotoController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 15.04.2023.
//

import UIKit

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
