//
//  VerifUserView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit

class VerifUserView : UIViewController {
    // variables
    var user : User?
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkUser()
    }
    
    func checkUser(){
        
        let token = UserDefaults.standard.string(forKey: "userToken")
        
        if token != nil {
            UserViewModel().getUserFromToken(userToken: token!) { success, user in
                if success {
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
                }
            }
        } else {
            self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
        }
    }
}
