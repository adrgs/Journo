//
//  LoginViewController.swift
//  Journo
//
//  Created by Dragos Albastroiu on 04.05.2022.
//

import UIKit
import SafariServices
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }

    private let usernameEmailField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "Email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("New User? Create an account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let googleButton = GIDSignInButton()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        
        
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didClickLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didClickCreateAccountButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didClickPrivacyButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didClickTermsButton), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(didClickGoogleButton), for: .touchUpInside)

        usernameEmailField.delegate = self
        passwordField.delegate = self
        
        addSubviews()
        
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height / 3.0)
        
        usernameEmailField.frame = CGRect(x: 25, y: headerView.bottom + 30, width: view.width-50, height: 52)
        passwordField.frame = CGRect(x: 25, y: usernameEmailField.bottom + 10, width: view.width-50, height: 52)
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width-50, height: 52)
        createAccountButton.frame = CGRect(x: 25, y: loginButton.bottom + 10, width: view.width-50, height: 52)
        googleButton.frame = CGRect(x: 25, y: createAccountButton.bottom + 10, width: view.width-50, height: 52)
        
        termsButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 100, width: view.width-20, height: 50)
        privacyButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 50, width: view.width-20, height: 50)
        
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        let imageView = UIImageView(image: UIImage(named:"logow"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0, y: view.safeAreaInsets.top, width: headerView.width/2.0, height: headerView.height - view.safeAreaInsets.top)
    }
    
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(googleButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(headerView)
    }
    
    @objc private func didClickLoginButton() {
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        var email: String?
        var username: String?
        
        // login functionality
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            email = usernameEmail
        } else {
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated:true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Log In Error", message: "Unable to log in", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
    @objc private func didClickCreateAccountButton() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func didClickTermsButton() {
        guard let url = URL(string:"https://policies.google.com/terms") else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc, animated: true)
    }
    
    @objc private func didClickPrivacyButton() {
        guard let url = URL(string:"https://policies.google.com/privacy") else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc, animated: true)
    }
    
    @objc private func didClickGoogleButton() {
        let signInConfig = GIDConfiguration.init(clientID: "997115990327-2qtqs1d7nqak6s3mhpm7t0urktetimh9.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            if let profiledata = user.profile {
                
                let userId : String = user.userID ?? ""
                // let givenName : String = profiledata.givenName ?? ""
                // let familyName : String = profiledata.familyName ?? ""
                let email : String = profiledata.email
                var absoluteurl : String?
                
                if let imgurl = user.profile?.imageURL(withDimension: 100) {
                    absoluteurl = imgurl.absoluteString
                    //HERE CALL YOUR SERVER API
                }
                
                let authentication = user.authentication
                guard let idToken = authentication.idToken else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
                  if error != nil {
                      let alert = UIAlertController(title: "Google Log In Error", message: "Unable to log in with Google", preferredStyle: .alert)
                      
                      alert.addAction(UIAlertAction(title:"Dismiss", style: .cancel, handler: nil))
                      
                      self.present(alert, animated: true)
                  } else {
                      let _ = DatabaseManager.shared.registerUser(username: userId, email: email, website: nil, bio: nil, phone: nil, gender: nil, pictureUrl: absoluteurl)
                      self.dismiss(animated:true, completion: nil)
                  }
                }
                
            }
        }
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didClickLoginButton()
        }
        
        return true
    }
}
