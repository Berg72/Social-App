//
//  SplashController.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/4/21.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import CryptoKit


class SplashController: UIViewController {
    
    private var currentNonce: String?
    private let scrollView = UIScrollView()
    private let titleView = UILabel()
    private let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userId = Auth.auth().currentUser?.uid {
            User.getUser(userID: userId) { (user, error) in
                guard let user = user else {
                    print(error)
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print(error)
                    }
                    return
                }
                Database.shared.currentUser = user
                let tabbar = Tabbar()
                self.navigationController?.pushViewController(tabbar, animated: true)
            }
            
        } else {
            UIViewPropertyAnimator(duration: 0.35, dampingRatio: 1.0) {
                self.appleButton.alpha = 1.0
            }.startAnimation()
            
        }
    }
}

private extension SplashController {
   
    func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
      
        
        let backGroundImage = UIImageView(image: UIImage(named: "BackGroundImage")?.withRenderingMode(.alwaysOriginal))
        backGroundImage.translatesAutoresizingMaskIntoConstraints = false
        backGroundImage.contentMode = .scaleAspectFill
        
        view.addSubview(backGroundImage)
        
        // Add the constraints / anchors
        backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backGroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        let appTitleLabel = UILabel()
        appTitleLabel.textAlignment = .center
        appTitleLabel.text = "Pet Living"
        appTitleLabel.font = UIFont.systemFont(ofSize: 42.0, weight: .bold)
        appTitleLabel.textColor = .white
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appTitleLabel)
        
        
        
        appTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 190.9).isActive = true
        appTitleLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let titleDescriptonLabel = UILabel()
        titleDescriptonLabel.textAlignment = .center
        titleDescriptonLabel.text = "A Meeting Place for your Beloved Pets"
        titleDescriptonLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .regular)
        titleDescriptonLabel.textColor = .white
        titleDescriptonLabel.translatesAutoresizingMaskIntoConstraints = false
        titleDescriptonLabel.lineBreakMode = .byWordWrapping
        titleDescriptonLabel.numberOfLines = 0
        self.view.addSubview(titleDescriptonLabel)
        
        titleDescriptonLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 24.0).isActive = true
        titleDescriptonLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        titleDescriptonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.cornerRadius = 6.0
        view.addSubview(appleButton)
        appleButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        appleButton.alpha = 0.0
        
            
        appleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72.0).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 52.0).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let termsButton = UIButton(type: .roundedRect)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        termsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        termsButton.setTitle("Terms & Conditions", for: .normal)
        termsButton.setTitleColor(.white, for: .normal)
        termsButton.addTarget(self, action: #selector(displayTermsAndConditions), for: .touchUpInside)
        view.addSubview(termsButton)
        
        termsButton.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor).isActive = true
        termsButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let privacyButton = UIButton(type: .roundedRect)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(.white, for: .normal)
        privacyButton.addTarget(self, action: #selector(displayPrivacyPolicy), for: .touchUpInside)
        view.addSubview(privacyButton)
        
        privacyButton.trailingAnchor.constraint(equalTo: appleButton.trailingAnchor).isActive = true
        privacyButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor).isActive = true
        privacyButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        
    }
    
    @objc
    func displayPrivacyPolicy() {
        guard let url = URL(string: "https://social-app-37fb9.web.app/privacy.html") else { return }
        let vc = WebController(url: url)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    @objc
    func displayTermsAndConditions() {
        guard let url = URL(string: "https://social-app-37fb9.web.app/terms.html") else { return }
        let vc = WebController(url: url)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
        
}
   
    private extension SplashController {
        
        @objc func handleAppleIdRequest() {
            let nonce = randomNonceString()
            currentNonce = nonce
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
        
        func randomNonceString(length: Int = 32) -> String {
          precondition(length > 0)
          let charset: Array<Character> =
              Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
          var result = ""
          var remainingLength = length

          while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
              var random: UInt8 = 0
              let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
              if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
              }
              return random
            }

            randoms.forEach { random in
              if remainingLength == 0 {
                return
              }

              if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
              }
            }
          }

          return result
        }
        
        @available(iOS 13, *)
        func sha256(_ input: String) -> String {
          let inputData = Data(input.utf8)
          let hashedData = SHA256.hash(data: inputData)
          let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
          }.joined()

          return hashString
        }
        
    }

extension SplashController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "Could not sign in", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let nonce = currentNonce else {
            return
        }
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        guard let token = credential.identityToken else {
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            return
        }
        
        let oAuthCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: oAuthCredential) { [weak self] (result, error) in
            
            
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            let email = credential.email
            
            self?.hasAccount(fistName: firstName, lastName: lastName, email: email)
            
        }
    }
    
    
    func hasAccount(fistName: String?, lastName: String?, email: String?) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let name = "\(fistName ?? "") \(lastName ?? "")"
        let date = Date().timeIntervalSince1970
        User.getUser(userID: userId) { (user, error) in
            guard let user = user else {
                let newUser = User(id: userId, apnsToken: nil, name: name, email: email, role: .user, profileImageUrl: nil, created: date, createdBy: userId, lastUpdated: date, lastUpdatedBy: userId, archived: false, archivedAt: nil)
                Database.shared.save(newUser) { (user, error) in
                    guard let user = user else {
                        print(error)
                        return
                    }
                    Database.shared.currentUser = user
                    let tabbar = Tabbar()
                    self.navigationController?.pushViewController(tabbar, animated: true)
                }
                
                return
            }
            Database.shared.currentUser = user
            let tabbar = Tabbar()
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
        
        
    }
    
}

