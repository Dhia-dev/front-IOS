//
//  DiscoverView.swift
//  Geochat
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit
import SnapKit

class PeopleView: UIViewController {
   
    var users : [User] = []
    var currentUser : User? // used for card swipe
    
    // another user for Me , the connected user
    var me : [User] = []
    var userCounter = 0
    var oldUiView : UIView?
    var newUiView : UIView?
    var currentLikeButton : UIButton?
    
    // like
    
    private var isLiked = false
      private let unlikedImage = UIImage(named: "emtyheart")
      private let likedImage = UIImage(named: "fillheart")
  
    
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var swipeAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfile()
    }
    
    
    func nextUser(swipeIsRight: Bool) {
        print("Switch user")
        if userCounter != users.count {
            currentUser = users[userCounter]
            
            oldUiView = newUiView
            
            if swipeIsRight {
                UIView.animate(withDuration: 1, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                // put here the code you would like to animate
                    self.oldUiView?.frame.origin.x = 1000
                    self.oldUiView?.frame.origin.y = 300
                    self.oldUiView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                }, completion: {(finished:Bool) in
                // the code you put here will be compiled once the animation finishes
                    self.oldUiView!.removeFromSuperview()
                })
            } else {
                UIView.animate(withDuration: 1, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
                // put here the code you would like to animate
                    self.oldUiView?.frame.origin.x = -1000
                    self.oldUiView?.frame.origin.y = 300
                    self.oldUiView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                }, completion: {(finished:Bool) in
                // the code you put here will be compiled once the animation finishes
                    self.oldUiView!.removeFromSuperview()
                })
            }
            
            
            newUiView = makeCard(username: users[userCounter].firstname! + " " + users[userCounter].lastname!, idPhoto: "profile-placeholder")
            swipeAreaView.addSubview(newUiView!)
            swipeAreaView.sendSubviewToBack(newUiView!)
            
            userCounter += 1
            
        } else {
            self.present(Alert.makeAlert(titre: "Notice", message: "Out of users !"),animated: true)
        }
    }
    
    func initProfile()  {
        UserViewModel().getAllUsers { [self] success, result in
           
            let allUsers = result!
            var filteredUsers : [User] = []
            // filter user here
            
            for  user in allUsers{
                let otherX = user.latitude
                let otherY = user.longitude
                
                let thisX = 36.84041798796328
                // currentUser?.latitude
                let thisY =  10.180012144476706
                // currentUser?.longitude
                let result1 =  otherX! - thisX
                let result2 = otherY! - thisY
           
                let result = pow(result1, 2) + pow(result2, 2)
                let distance = sqrt(Double(result))

                
                if ( distance < 0.9 ) {
                    filteredUsers.append(user)
                    
                }
                
                
            }
            
  
          
          //  users = []
            users = filteredUsers
            
            newUiView = makeCard(username: users[userCounter].firstname! + " " + users[userCounter].lastname!, idPhoto: "profile-placeholder")
            
            swipeAreaView.addSubview(newUiView!)
            
            currentUser = users[userCounter]
        }
    }
    
    func makeCard(username: String , idPhoto: String) -> UIView {
        let card = UIView()
        card.frame = CGRect(x: 0, y: 0, width: swipeAreaView.frame.width, height: swipeAreaView.frame.height)
        card.backgroundColor = UIColor(white: 0.9, alpha: 1)
        card.layer.cornerRadius = 20
        
        let image = UIImageView(image: UIImage(named: idPhoto))
        image.frame = CGRect(x: 20, y: 20, width: card.frame.width - 40, height: card.frame.height - 150)
        image.contentMode = .scaleAspectFit
        image.tag = 1
        image.layer.cornerRadius = 20
        
        let usernameLabel = UILabel()
        usernameLabel.tag = 2
        usernameLabel.text = username
        usernameLabel.frame = CGRect(x: 0, y: image.frame.height + 50, width: card.frame.width, height: 50)
        usernameLabel.textAlignment = .center
        
        let sendMessageButton = UIButton()
        sendMessageButton.setTitle("Send a message", for: .normal)
        sendMessageButton.setTitleColor(UIColor.tintColor, for: .normal)
        sendMessageButton.frame = CGRect(x: 30, y: image.frame.height + 100, width: card.frame.width / 2, height: 40)
        sendMessageButton.addTarget(self, action: #selector(PeopleView.sendMessageButtonAction), for: .touchUpInside)
        
        let likeButton = UIButton()
        likeButton.setImage( UIImage(named: "emtyheart"), for: .normal)
        likeButton.setTitleColor(UIColor.blue, for: .normal)
        likeButton.frame = CGRect(x: sendMessageButton.frame.width + 70, y: image.frame.height + 90, width: card.frame.width / 3, height: 40)
        likeButton.addTarget(self, action: #selector(PeopleView.likeButtonAction), for: .touchUpInside)

        currentLikeButton = likeButton
        
        card.addSubview(image)
        card.addSubview(usernameLabel)
       card.addSubview(likeButton)
        card.addSubview(sendMessageButton)
        
        return card
    }
    
    @objc func sendMessageButtonAction() {
        let chat = Chat(date: Date(), lastMessage: "This chat hasn't started yet")
        ChatViewModel().addChat(chat: chat,
                                senderId: UserDefaults.standard.string(forKey: "userId")! ,
                                receiverId: (currentUser?._id)!,
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
    
    @objc func likeButtonAction(sender: UIButton) {
   
        // lil heartbutton

        self.flipLikedState()
        
        LikeViewModel().addLike(like: Like(seen: false, liked: currentUser)) { success in
            self.currentLikeButton?.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    @IBAction func leftSwipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer ) {
        if gestureRecognizer.state == .ended {
            nextUser(swipeIsRight: false)
        }
    }
    
    @IBAction func rightSwipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer ) {
        if gestureRecognizer.state == .ended {
            nextUser(swipeIsRight: true)
        }
    }
    
    // methods for like animation
    
    public func flipLikedState() {
            isLiked = !isLiked
            animate()
          }

          private func animate() {
            // Step 1
            UIView.animate(withDuration: 0.1, animations: {
              let newImage = self.isLiked ? self.likedImage : self.unlikedImage
                self.currentLikeButton!.transform =  self.currentLikeButton!.transform.scaledBy(x: 0.8, y: 0.8)
                self.currentLikeButton!.setImage(newImage, for: .normal)
            }, completion: { _ in
              // Step 2
              UIView.animate(withDuration: 0.1, animations: {
                  self.currentLikeButton!.transform = CGAffineTransform.identity
              })
            })
          }
}
