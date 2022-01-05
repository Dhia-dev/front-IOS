//
//  LoginView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import UIKit
import SwiftUI
import GoogleSignIn

class LoginView: UIViewController {

    // variables
    var email : String?
    let spinner = SpinnerViewController()
    let googleSignInConfig = GIDConfiguration.init(clientID: "518820513360-4in0u0h39uevaoe9tojq7t9bmalil5ob.apps.googleusercontent.com")
    let googleLoginButton = GIDSignInButton()
    
    // iboutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var googleLoginProviderStackView: UIStackView! // Google login button
    
    // protocols
    
    // facebok btn
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginProviderStackView.addSubview(googleLoginButton)
        
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)

        if email != nil {
            emailTF.text = email
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        googleLoginButton.frame = CGRect(x: 0, y: 0, width: googleLoginProviderStackView.frame.width, height: googleLoginProviderStackView.frame.height)
        
    }
    
    // methods
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    @objc func googleSignIn() {
        
        GIDSignIn.sharedInstance.signIn(with: googleSignInConfig, presenting: self) { [self] user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            let email = user.profile?.email
            let firstname = (user.profile?.givenName)!
            let lastname = (user.profile?.familyName)!
            
            
            UserViewModel().loginWithSocialApp(email: email!, firstname: firstname, lastname: lastname, completed: { success, user in
                if success {
                    self.proceedToLogin(user: user!)
                } else {
                    self.present(Alert.makeAlert(titre: "Error", message: "Could not login with Google"), animated: true)
                }
                
                self.stopSpinner()
            })
            
            stopSpinner()
        }
    }
    
    func resendConfirmationEmail(email: String?) {
        UserViewModel().resendConfirmation(email: email!, completed: { (success) in
            if success {
                self.present(Alert.makeAlert(titre: "Success", message: "Confirmation email has been sent to " + email!), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not send verification email"), animated: true)
            }
        })
    }
    
    func proceedToLogin(user: User) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    // actions
    @IBAction func login(_ sender: Any) {
        
        if(emailTF.text!.isEmpty || passwordTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must type your credentials"), animated: true)
            return
        }
        
        startSpinner()
        
        let email = emailTF.text!
        let password = passwordTF.text!
        
        UserViewModel().login(email: email, password: password, completed: { (success, response) in
            self.stopSpinner()
            if success {
                let user = response as! User
                
                if (user.isVerified!) {
                    self.proceedToLogin(user: user)
                } else {
                    let action = UIAlertAction(title: "Resend", style: .default) { UIAlertAction in
                        self.resendConfirmationEmail(email: email)
                    }
                    self.present(Alert.makeActionAlert(titre: "Notice", message: "The email linked to this account is not confirmed, would you like to resend the confirmation email ?", action: action), animated: true)
                }
            } else {
                self.present(Alert.makeAlert(titre: "Warning", message: "Email or password incorrect"),animated: true)
            }
        })
    }
}
