//
//  ChooseUserView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit

class ChooseUserView: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // variables
    var users : [User] = []
    
    // iboutlets
    @IBOutlet weak var tableView: UITableView!
    
    // protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentView = mCell?.contentView
        
        let userImage = contentView?.viewWithTag(1) as! UIImageView
        let usernameLabel = contentView?.viewWithTag(2) as! UILabel
        let locationLabel = contentView?.viewWithTag(3) as! UILabel
        
        let currentUser = users[indexPath.row]
        
        //userImage.image = UIImage(named: "")
        if currentUser.firstname != nil && currentUser.lastname != nil {
            usernameLabel.text = (currentUser.firstname)! + " " + (currentUser.lastname)!
        }
        locationLabel.text = currentUser.location
        
        return mCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = Chat(date: Date(), lastMessage: "This chat hasn't started yet")
        ChatViewModel().addChat(
            chat: chat,
            senderId: users[indexPath.row]._id!,
            receiverId: UserDefaults.standard.string(forKey: "userId")!,
            receiverMsgs: [] ,
             senderMsgs: []
     ,completed: { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not add chat"),animated: true)
            }
        })
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeHistory()
    }
    
    // methods
    func initializeHistory() {
        UserViewModel().getAllUsers { success, usersFromRep in
            if success {
                self.users = usersFromRep!
                self.tableView.reloadData()
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load history"),animated: true)
            }
        }
    }
    
    // actions
    
}
