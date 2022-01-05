//
//  ChatViewModel.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage
import Foundation

class ChatViewModel {
    
    
    func getMyChats(completed: @escaping (Bool, [Chat]?) -> Void ) {
        AF.request(Constants.serverUrl + "/chat/my",
                   method: .post,
                   parameters: [
                    "sender": UserDefaults.standard.string(forKey: "userId")!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var chats : [Chat]? = []
                    for singleJsonItem in JSON(response.data!)["chats"] {
                        chats!.append(self.makeChat(jsonItem: singleJsonItem.1))
                    }
                    completed(true, chats)
                    
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getChatById(_id: String?, completed: @escaping (Bool, Chat?) -> Void ) {
        AF.request(Constants.serverUrl + "/chat/by-id",
                   method: .post,
                   // this was .get but i changet to /post because the method is declared POst in Insomnia , f node yaani
                   // bil .get matimchich
                   // bil post timchy lekin matrajaach il id , trajaa null fil id mtaa Chat 
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                
                    let chat = self.makeChat(jsonItem: jsonData["chats"])
                    completed(true, chat)
                case let .failure(error):
                    print(error)
                    completed(false, nil)
                }
            }
    }

    func addChat(chat: Chat,
                 senderId: String,
                 receiverId: String,
                 receiverMsgs: Array<Message> ,
                 senderMsgs: Array<Message>,
                 completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/chat/",
                   method: .post,
                   parameters: [
                    "date": chat.date!,
                    "lastMessage": chat.lastMessage!,
                    "sender": senderId,
                    "receiver": receiverId,
                    "receiverMsgs": receiverMsgs,
                    "senderMsgs" : senderMsgs,
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editChat(chat: Chat, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/chat/",
                   method: .put,
                   parameters: [
                    "_id": chat._id!,
                    "date": chat.date!,
                    "lastMessage": chat.lastMessage!,
                    "sender": chat.sender!._id!,
                    "receiver": chat.receiver!._id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func deleteChat(_id: String?, completed: @escaping (Bool) -> Void ) {
        
        AF.request(Constants.serverUrl + "/chat/",
                   method: .delete,
                   parameters: [
                    "_id": _id!
                   ],
                   encoding: URLEncoding.httpBody)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func makeChat(jsonItem: JSON)  -> Chat {
        // make a msg
        var senderMsgs : [Message] = []
        var recieverMsgs : [Message] = []
        

        
        var x = jsonItem["senderMsgs"]
        
        
 
//
//                    if let json = jsonItem as? [String: Any] {
//                        // try to read out a dictionary
//                            if let senderMs = json["senderMsgs"] as? [[String:Any]] {
//                                print(senderMs)
//                                let dict = senderMs[0]
//                                print(dict)
//                                if let text = dict["text"] as? String{
//                                    print(text)
//                                    // add to the lits
//                                    senderMsgs.append(Message(_id: "0", seen: false, text: text, seenDate: Date.now, sentDate: Date.now))
//                }
//                            }
//            if let recieverMs = json["recieverMsgs"] as? [[String:Any]] {
//                print(recieverMs)
//                let dict = recieverMs[0]
//                print(dict)
//                if let text = dict["text"] as? String{
//                    print(text)
//                    // add to the lits
//                    recieverMsgs.append(Message(_id: "0", seen: false, text: text, seenDate: Date.now, sentDate: Date.now))
//                }
//            }
         
                  //  }
       return  Chat(
            _id: jsonItem["_id"].stringValue,
            senderMsgs: senderMsgs,
            recieverMsgs: recieverMsgs,
             date: Date(), //jsonItem["date"].stringValue,
            lastMessage: jsonItem["lastMessage"].stringValue,
            sender: makeUser(jsonItem: jsonItem["sender"]),
            receiver: makeUser(jsonItem: jsonItem["receiver"])
        )
    }
  
    
    func makeUser(jsonItem: JSON) -> User {
        return User(
            _id: jsonItem["_id"].stringValue,
            email: jsonItem["email"].stringValue,
            password: jsonItem["password"].stringValue,
            firstname: jsonItem["firstname"].stringValue,
            lastname: jsonItem["lastname"].stringValue,
            age: jsonItem["age"].intValue,
            sexe: jsonItem["sexe"].stringValue,
            location: jsonItem["location"].stringValue,
            isVerified: jsonItem["isVerified"].boolValue
        )
    }
}
