//
//  ChatView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit 

class ChatView: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // variables
   
    
    // user
    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var me: User?
    var senderUser : User?
    var senders : [User] = []
    
    
    var chats : [Chat] = []
    var currentChat : Chat?
    var refreshTimer : Timer?
    
    // iboutlets
    @IBOutlet weak var tableView: UITableView!
    
    // protocols
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChatSegue" {
            let destination = segue.destination as! MessagesView
            if currentChat?.receiver?.firstname != nil && currentChat?.receiver?.lastname != nil {
                destination.title = (currentChat?.receiver?.firstname)! + " " + (currentChat?.receiver?.lastname)!
                
                // send the ids , SenderId and the Chat id
                
                destination.senderId = currentChat!.receiver!._id!
                destination.chatId = currentChat!._id!
                
                
                
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentView = mCell?.contentView
        
        let userImage = contentView?.viewWithTag(1) as! UIImageView
        let usernameLabel = contentView?.viewWithTag(2) as! UILabel
        let lastMessageLabel = contentView?.viewWithTag(3) as! UILabel
        let messageCountLabel = contentView?.viewWithTag(4) as! UILabel
        
        let thisChat = chats[chats.count - indexPath.row - 1]
        
// let thisChat = chats[indexPath.row ]
        
        //userImage.image = UIImage(named: "")
        if thisChat.receiver?.firstname != nil && thisChat.receiver?.lastname != nil {
            usernameLabel.text = (thisChat.receiver?.firstname)! + " " + (thisChat.receiver?.lastname)!
        }
        lastMessageLabel.text = thisChat.lastMessage
        messageCountLabel.text = "1"
        
        return mCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // currentChat = chats[indexPath.row]
        currentChat = chats[chats.count - indexPath.row - 1]
        self.performSegue(withIdentifier: "openChatSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            ChatViewModel().deleteChat(_id: chats[indexPath.row]._id) { success in
                if success {
                    print("deleted chat")
                    self.chats.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                    print("error while deleting chat")
                }
            }
        }
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeUsers()
        initializeHistory()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeHistory()
    }
    
    // methods
    func startTimer () {
        guard refreshTimer == nil else { return }
        
        refreshTimer =  Timer.scheduledTimer(
            timeInterval: 5,
            target      : self,
            selector    : #selector(update),
            userInfo    : nil,
            repeats     : true)
    }
    
    // initialiazing the current user , from token
    
    // methods
    func initializeUsers() {
        print("initializing Users")
        UserViewModel().getUserFromToken(userToken: token, completed: { [self] success, result in
            me = result
              if success {
                  
                  /// init USER
                  /// // the sender MEE
                  /// TjheREciever Got from list
                  ///
                  /// init them for dataBase
                  ///
                  /// LIst of SEnders
                  ///
                  ///
                  ///
                  me = result
                  senderUser = User(  _id: "2", email: "", password: "", firstname: "Alex", lastname: "Aouiti", age: 12, latitude: 0, longitude: 0, sexe: "Man", location: "somewhere", isVerified: true)
                
               /*  firstnameTF.text = user?.firstname
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
                
                */
                
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
              
        })
    }
    
    
    
    @objc
    func update()  {
        initializeHistory()
    }
    
    func initializeHistory() {
        ChatViewModel().getMyChats { success, chatsFromRep in
            if success {
                self.chats = chatsFromRep!
                for chat in chatsFromRep! {
                    self.senders.append(chat.sender!)
                }
            
                print(self.chats)
                
               // self.chats = [ Chat( _id: "1", date: Date.now, lastMessage: "ITs time for ...", sender: self.senderUser, receiver: self.user) ]
                
                self.tableView.reloadData()
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load history"),animated: true)
            }
        }
        tableView.reloadData()
    }
    
    // actions
    
}
