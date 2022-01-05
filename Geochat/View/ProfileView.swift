//
//  ProfileView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit

protocol ModalDelegate {
    func initProfileFromEdit()
}

class ProfileView: UIViewController, ModalDelegate {

    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user: User?

    
    // iboutlets
    
    @IBOutlet weak var showQrOutlet: UIImageView!
    
    
    
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    
    // protocols
    func initProfileFromEdit() {
        initializeProfile()
        
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.isEnabled = false
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        showQrOutlet.addGestureRecognizer(tapGR)
        showQrOutlet.isUserInteractionEnabled = true
        initializeProfile()
    }
    // ddded to send the userINfo
    // protocols
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQrSeg" {
            let destination = segue.destination as! QrCodeViewController
            destination.userInfo = firstnameTF.text! + " " + lastnameTF.text! + ": Contact: " + emailTF.text!
        }
        
    }
    
    // this image is called when clicked the image
    // then opens the Qr Code page
    @objc func imageTapped(sender: UITapGestureRecognizer) {
                    if sender.state == .ended {
                        performSegue(withIdentifier: "showQrSeg", sender: nil)
                    }
            }
    // methods
    func initializeProfile() {
        print("initializing profile")
        UserViewModel().getUserFromToken(userToken: token, completed: { [self] success, result in
            user = result
            if success {
                // init the image
                
                firstnameTF.text = user?.firstname
                lastnameTF.text = user?.lastname
                if user?.age != nil {
                    ageTF.text = String((user?.age)!)
                }
                locationTF.text = user?.location
                emailTF.text = user?.email
            
                
                switch user?.sexe {
                 case "Man":
                    genderControl.selectedSegmentIndex = 0
                 case "Women":
                    genderControl.selectedSegmentIndex = 1
                 default:
                     break;
                 }  //Switch
                
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
        })
    }
    
    // actions
    
    
    @IBAction func confirmChanges(_ sender: Any) {
        
        if (firstnameTF.text!.isEmpty || lastnameTF.text!.isEmpty || ageTF.text!.isEmpty || locationTF.text!.isEmpty || emailTF.text!.isEmpty ){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must fill all the fields"),animated: true)
            return
        }
        
        if Int(ageTF.text!) == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Age should be a number"),animated: true)
            return
        }
        
        
        let firstname = firstnameTF.text
        let lastname = lastnameTF.text
        let age = Int(ageTF.text!)
        let location = locationTF.text
        let email = emailTF.text
        
        var gender = ""
        
        switch genderControl.selectedSegmentIndex {
         case 0:
            gender = "Man"
         case 1:
            gender = "Women"
         default:
             break;
         }  //Switch
        
        user?.email = email
        user?.firstname = firstname
        user?.lastname = lastname
        user?.age = age
        user?.location = location
        user?.sexe = gender
        
        UserViewModel().editProfile(user: user!) { success in
            if success {
                //self.initializeProfile()
                let action = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
                    
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Profile edited successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not edit your profile"), animated: true)
            }
        }
    
    }
}
