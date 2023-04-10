//
//  SettingsTableViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 7.04.2023.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let padding: CGFloat = 16
    lazy var imageOneButton = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageTwoButton = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageThreeButton = createButton(selector: #selector(handleSelectPhoto))
    
    let hud = JGProgressHUD(style: .light)
    
    lazy var headerView: UIView = {
        let header = UIView()
        imageOneButton.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(imageOneButton)
        imageOneButton.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageOneButton.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [imageTwoButton, imageThreeButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: imageOneButton.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))

        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
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
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.8) else { return }
        hud.textLabel.text = "Uploading image"
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            if let err = err {
                self.hud.dismiss()
                print("failed to upload image to storage", err)
            }
            print("Succesfull")
            ref.downloadURL { [self] (url, err) in
                self.hud.dismiss()
                if let err = err {
                    print("failed to retrieved download URL", err)
                    return
                }
                print("Finsihed download:", url?.absoluteString ?? "")
                
                if imageButton == self.imageOneButton {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.imageTwoButton {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(Placeholder.selectPhoto, for: .normal)
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
        configureTableView()
        fetchCurrentUser()
    }
    
    var user: User?
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
            }
            guard let dictionary = snapshot?.data() else { return }
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.imageOneButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.imageTwoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.imageThreeButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = HeaderText.name
        case 2:
            headerLabel.text = HeaderText.profession
        case 3:
            headerLabel.text = HeaderText.age
        default:
            headerLabel.text = HeaderText.bio
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = Placeholder.name
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = Placeholder.profession
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = Placeholder.age
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = Placeholder.bio
        }
        
        return cell
    }
    
    @objc private func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc private func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc private func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    private func configureTableView() {
        tableView.backgroundColor = Color.tableView
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
  
    private func configureNavigationController() {
        navigationItem.title = NavigationItemText.settings
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NavigationItemText.cancel, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: NavigationItemText.save, style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: NavigationItemText.logout, style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc private func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullname": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? ""
        ]
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to save user settings:", err)
                return
            }
            
            print("Finished saving user info")
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
}
