//
//  LoginViewController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 11.04.2023.
//

import UIKit
import JGProgressHUD

protocol LoginViewControllerDelegate {
    func didFinishLoggingIn()
}

class LoginViewController: UIViewController {
    
    let emailTextField = CustomTextField(placeholder: Placeholder.email, keyboardType: .emailAddress)
    let passwordTextField = CustomTextField(placeholder: Placeholder.password, keyboardType: .default)
    let loginButton = CustomButton(title: Title.login)
    let goToRegisterButton = GoToButton(title: Title.goToRegister)
    let hud = JGProgressHUD(style: .light)
    let loginViewModel = LoginViewModel()
    let gradientLayer = CAGradientLayer()
    
    var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        configureStackView()
        setupBindables()
        handleTapGesture()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginButton()
        configureGoToRegisterButton()
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureEmailTextField() {
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    private func configurePasswordTextField() {
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
    }
    
    @objc private func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to log in:", err)
                return
            }
            print("Logged in successfully")
            self.hud.dismiss()
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    private func configureGoToRegisterButton() {
        view.addSubview(goToRegisterButton)
        goToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        goToRegisterButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        loginViewModel.isLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.hud.textLabel.text = Title.register
                self.hud.show(in: self.view)
            } else {
                self.hud.dismiss()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupGradientLayer() {
        let topColor = Color.top
        let bottomColor = Color.bottom
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    private func handleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
     
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

