//
//  SettingsTableViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 7.04.2023.
//

import UIKit

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var imageOneButton = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageTwoButton = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageThreeButton = createButton(selector: #selector(handleSelectPhoto))
    
    let headerView = UIView()
    
    @objc private func handleSelectPhoto(button: UIButton) {
        let imagePickerController = CustomImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = button
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
     

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        configureImageOneButton()
        configureStackView()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    let padding: CGFloat = 16
    
    private func configureImageOneButton() {
        headerView.addSubview(imageOneButton)
        imageOneButton.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageOneButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
    }
    
    //configure imageTwoButton, imageThreeButton
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [imageTwoButton, imageThreeButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, leading: imageOneButton.trailingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    private func configureNavigationController() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
}
