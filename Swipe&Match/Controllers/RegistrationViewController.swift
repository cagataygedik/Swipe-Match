//
//  RegistrationViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 31.03.2023.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    let selectPhotoButton = SelectPhotoButton(frame: .zero)
    let fullNameTextField = CustomTextField(placeholder: Placeholder.fullName, keyboardType: .emailAddress)
    let emailTextField = CustomTextField(placeholder: Placeholder.email, keyboardType: .emailAddress)
    let passwordTextField = CustomTextField(placeholder: Placeholder.password, keyboardType: .default)
    let registerButton = RegisterButton(type: .system)
    let registeringHUD = JGProgressHUD(style: .dark)
    
    /*
    let selectPhotoButton: SelectPhotoButton = {
        let button = SelectPhotoButton(type: .system)
        return button
    }()
     
    
    
    lazy var fullNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Placeholder.fullName, keyboardType: .default)
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
     
    
    
    lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Placeholder.email, keyboardType: .emailAddress)
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
     
    
    
    lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: Placeholder.password, keyboardType: .default)
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()
     
    
    lazy var registerButton: RegisterButton = {
        let button = RegisterButton(type: .system)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        configureView()
        setupNotificationObservers()
        handleTapGesture()
        configureSelectPhotoButton()
        configureFullNameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureRegisterButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureSelectPhotoButton() {
        selectPhotoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
    }
    
    private func configureFullNameTextField() {
       fullNameTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    private func configureEmailTextField() {
       emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    private func configurePasswordTextField() {
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
    }
    
    private func configureRegisterButton() {
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc private func handleRegister() {
        self.dismissKeyboard()
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        registeringHUD.textLabel.text = "Registering"
        registeringHUD.show(in: view)
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (res, err) in
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            print("Registered user:", res?.user.uid ?? "")
            
            let image = self.selectPhotoButton.imageView?.image
            let imageData = image?.jpegData(compressionQuality: 0.8) ?? Data()
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference(withPath: "/images\(imageName)")
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("failed to upload image:", error)
                    self.showHUDWithError(error: error)
                    return
                }
                print("Successfully upload image")
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        self.showHUDWithError(error: err)
                        return
                    }
                    self.registeringHUD.dismiss()
                    print("Download the url of the image is:", url?.absoluteString ?? "")
                }
            }
        }
    }
    
    private func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    @objc private func handleTextChange() {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
        registerButton.isEnabled = false
        registerButton.backgroundColor = .lightGray
        return
        }
        registerButton.isEnabled = true
        registerButton.backgroundColor = Color.button
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height - 180
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    private func handleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureView() {
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, registerButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = Color.top
        let bottomColor = Color.bottom
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
