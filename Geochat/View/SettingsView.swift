//
//  SettingsView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit

class SettingsView: UIViewController {
    
    
    @IBOutlet weak var mapButton: UIButton!
    
    let token = UserDefaults.standard.string(forKey: "userToken")
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialize()
    }
    
    func initialize(){
        if token != nil {
            UserViewModel().getUserFromToken(userToken: token!) { success, user in
                if success {
                    self.usernameLabel.text = (user?.firstname)! + " " + (user?.lastname)!
                } else {
                    self.present(Alert.makeAlert(titre: "Error", message: "Could not load user"),animated: true)
                }
            }
        } else {
            print("token is nil")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender:nil)
    }
}
