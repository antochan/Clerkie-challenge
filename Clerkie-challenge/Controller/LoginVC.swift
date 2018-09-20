//
//  LoginVC.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/19.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie
import TextFieldEffects
import TransitionButton
import PopupDialog

class LoginVC: UIViewController {
    
    let loginButton = TransitionButton()
    let signupButton = UIButton()
    let passwordTextField = IsaoTextField()
    let emailTextField = IsaoTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        logoAnimate()
        setUpEmailTextField()
        setUpPasswordTextField()
        setUpLoginButton()
        setUpSignupButton()
    }
    
    func logoAnimate() {
        let animationView = LOTAnimationView(name: "Logo")
        animationView.contentMode = .scaleAspectFill
        
        animationView.frame = CGRect(x:0, y: 40, width:240, height:240)
        animationView.center.x = self.view.center.x
        
        
        self.view.addSubview(animationView)
        animationView.play{ (finished) in
            //TODO: put label
        }
    }
    
    func setUpNavigationBar() {
        
        //clear navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //back button
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        
        navigationController?.navigationBar.isHidden = false
        
    }
    
    fileprivate func setUpEmailTextField() {
        // email textfield
        view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 280).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.font = UIFont.avenirNextRegularFontOfSize(size: 15)
        emailTextField.inactiveColor = .white
        emailTextField.activeColor = UIColor.FlatColor.Yellow.PastelYellow
        emailTextField.placeholder = "Email / Phone"
        emailTextField.keyboardType = .emailAddress
    }
    
    fileprivate func setUpPasswordTextField() {
        //password text field
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 280).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.font = UIFont.avenirNextRegularFontOfSize(size: 15)
        passwordTextField.inactiveColor = .white
        passwordTextField.activeColor = UIColor.FlatColor.Yellow.PastelYellow
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
    }
    
    fileprivate func setUpLoginButton() {
        //submit button
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 170).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.titleLabel?.font = UIFont.avenirNextDemiBoldFontOfSize(size: 15)
        loginButton.backgroundColor = .clear
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.setTitle("Login", for: .normal)
        loginButton.cornerRadius = 20
        loginButton.spinnerColor = .white
        loginButton.addTarget(self, action: #selector(initiateLogin(_:)), for: .touchUpInside)
    }
    
    fileprivate func setUpSignupButton() {
        //submit button
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 230).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signupButton.titleLabel?.font = UIFont.avenirNextDemiBoldFontOfSize(size: 15)
        signupButton.backgroundColor = .white
        signupButton.setTitle("Signup", for: .normal)
        signupButton.setTitleColor(UIColor.FlatColor.Blue.PastelBlue, for: .normal)
        signupButton.layer.cornerRadius = 20
        signupButton.addTarget(self, action: #selector(initiateSignupForm), for: .touchUpInside)
    }
    
    @objc func initiateLogin(_ button: TransitionButton) {
        
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text , passwordTextField.text != "" else { return }
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: { [weak self] in
            
        guard let strongSelf = self else { return }
            
            //Do Auth Service calls here
            
        })
    }
    
    @objc func initiateSignupForm() {
        // Create a custom view controller
        let signupVC = SignupVC()
        
        // Create the dialog
        let popup = PopupDialog(viewController: signupVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            print("You canceled the rating dialog")
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            print("swag")
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
        
    }

}


extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
