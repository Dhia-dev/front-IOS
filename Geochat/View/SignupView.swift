//
//  SignupView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import UIKit
import GoogleSignIn

class SignupView: UIViewController {

    // variables
    let spinner = SpinnerViewController()
    var emailToLogin: String?
    let googleSignInConfig = GIDConfiguration.init(clientID: "518820513360-4in0u0h39uevaoe9tojq7t9bmalil5ob.apps.googleusercontent.com")
    let googleLoginButton = GIDSignInButton()
    
    // iboutlets
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    @IBOutlet weak var sexeControl: UISegmentedControl!
    @IBOutlet weak var googleLoginProviderStackView: UIStackView!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "redirectToLogin" {
            let destination = segue.destination as! LoginView
            destination.email = emailToLogin
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginProviderStackView.addSubview(googleLoginButton)
        
        googleLoginButton.addTarget(self, action: #selector(googleSignUp), for: .touchUpInside)
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
    
    func signUp(user: User){
        UserViewModel().signUp(user: user, completed: { (success) in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    
                    self.performSegue(withIdentifier: "redirectToLogin", sender: user.email)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Notice", message: "Inscription as successful, a confirmation email has been sent to " + user.email! + ", please open it and click on the link.", action: action),animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Registration failed, email elready registered"), animated: true)
            }
        })
    }
    
    @objc func googleSignUp() {
        
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
    
    func proceedToLogin(user: User) {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    // actions
    @IBAction func register(_ sender: Any) {
        
        // label foug kol wahda
        // email validation
        
        if (firstnameTF.text!.isEmpty || lastnameTF.text!.isEmpty || ageTF.text!.isEmpty || locationTF.text!.isEmpty || emailTF.text!.isEmpty || passwordTF.text!.isEmpty || passwordConfirmationTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must fill all the fields"),animated: true)
            return
        }
        
        if Int(ageTF.text!) == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Age should be a number"),animated: true)
            return
        }
        
        if !isValidEmail(emailTF.text!){
            self.present(Alert.makeAlert(titre: "Warning", message: "Please Enter a Valid Email"),animated: true)
            return
        }
        
        if (passwordTF.text != passwordConfirmationTF.text){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password and confirmation don't match"), animated: true)
            return
        }
        
        let email = emailTF.text
        let password = passwordTF.text
        let firstname = firstnameTF.text
        let lastname = lastnameTF.text
        let age = Int(ageTF.text!)
        let location = locationTF.text
        
        var sexe = ""
        
        switch sexeControl.selectedSegmentIndex {
         case 0:
            sexe = "Man"
         case 1:
            sexe = "Women"
         default:
             break;
         }  //Switch
        
        
        let user = User(email: email, password: password, firstname: firstname, lastname: lastname, age: age, sexe: sexe, location: location, isVerified: false)
        
        self.signUp(user: user)
    }
    
    @IBAction func redirectToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "redirectToLogin", sender: nil)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
