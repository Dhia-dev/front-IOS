//
//  MessagesView.swift
//  Geochat
//
//  Created by Apple Mac on 5/12/2021.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView
import SwiftUI
import MapKit


struct Sender : SenderType {
    var senderId: String
    var displayName: String
}
struct MessageItem: MessageType {
     var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind : MessageKind
    
}

class MessagesView: MessagesViewController ,MessagesDataSource , MessagesLayoutDelegate , MessagesDisplayDelegate , InputBarAccessoryViewDelegate{
    
   // variables
    var senderId = String()
    var chatId  = String()
    var thisChat = Chat()

    let currentUser = Sender(senderId: "self", displayName: "Ala Aouiti STatic")
    let OtherUser = Sender(senderId: "other", displayName: "Alex Aouiti")
    // list of message
    //
    // new
    
    //
    var senderMsgs = [Message] ()
    var recieverMsgs = [Message] ()
    var messages = [MessageType] ()
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // init messages
        ChatViewModel().getChatById(_id: chatId, completed: { result, chat   in
          // get msgs from this chat
            
            if (result )   {
                self.senderMsgs = chat!.senderMsgs
                self.recieverMsgs = chat!.recieverMsgs
        

            }  else {
                print("we could not get youuuuuuuuuuuuurrrrrrrrrrrrr chhhhatttttt ")
            }
        } )
        
        // append the messages
        messages.append(MessageItem(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-9000), kind: .text("Hello there")))
             
        messages.append(MessageItem(sender: currentUser, messageId: "2", sentDate: Date().addingTimeInterval(-8000), kind: .text("Hello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLOHello HELLO")))
        messages.append(MessageItem(sender: OtherUser, messageId: "3", sentDate: Date().addingTimeInterval(-7000), kind: .text("WE STILL TESTING THE CHAT")))
        messages.append(MessageItem(sender: currentUser, messageId: "4", sentDate: Date().addingTimeInterval(-6000), kind: .text("THAT IS GREAT BRO")))
        messages.append(MessageItem(sender: OtherUser, messageId: "5", sentDate: Date().addingTimeInterval(-5000), kind: .text("WE ARE GOING BACK .......")))
        messages.append(MessageItem(sender: currentUser, messageId: "6", sentDate: Date().addingTimeInterval(-4000), kind: .text("GOOD BYE")))
//        for msg in senderMsgs {
//
//            messages.append(
//                MessageItem(sender: currentUser, messageId: msg._id!, sentDate: Date().addingTimeInterval(-8000), kind: .text(msg.text!)))
//        }
//
//        for msg in recieverMsgs {
//
//            messages.append(
//                MessageItem(sender: OtherUser, messageId: msg._id!, sentDate: Date().addingTimeInterval(-8000), kind: .text(msg.text!)))
//        }
        
     
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
    }
    
    
    
    func currentSender() -> SenderType {

        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
   
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
   
        // 1::: add the new massge to message list
        
        let id = String ( messages.count + 1 )
        
        messages.append(MessageItem(
            sender: currentUser, messageId: id
            , sentDate: Date.now, kind: .text(text)))
        
        // 2 ::: refresh  and add the new massge to the list
        
       self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem()
        
        // 3 ::: eemty the input text field
        
        inputBar.inputTextView.text = ""
        
      

       
        
    }

    
    func initMsgs() {
        ChatViewModel().getChatById(_id: chatId, completed: { result, chat   in
          // get msgs from this chat
            
            if (result )   {
                self.senderMsgs = chat!.senderMsgs
                self.recieverMsgs = chat!.recieverMsgs
                

            }  else {
                print("we could not get youuuuuuuuuuuuurrrrrrrrrrrrr chhhhatttttt ")
            }
        } )
        
        // append the messages
        messages.append(MessageItem(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-9000), kind: .text("Hello there")))
        for msg in senderMsgs {
            
            messages.append(
                MessageItem(sender: currentUser, messageId: msg._id!, sentDate: Date().addingTimeInterval(-8000), kind: .text(msg.text!)))
        }
        
        for msg in recieverMsgs {
            
            messages.append(
                MessageItem(sender: OtherUser, messageId: msg._id!, sentDate: Date().addingTimeInterval(-8000), kind: .text(msg.text!)))
        }
        
        
        
    }
    
    // jit les msgs bil base èothom f list hadhika w baad call this method in the init method
    
    //  like not showing bybdefault
    
    // choufilha 7al
    
    // rating
    
    // add rating for each user
    
    // get user image
    
    // 
    
}
