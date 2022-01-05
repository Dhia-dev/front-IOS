//
//  MessageViewModel.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class MessageViewModel {
    
    func getAllMessage(completed: @escaping (Bool, [Message]?) -> Void ) {
        AF.request(Constants.serverUrl + "/message/",
                   method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var messages : [Message]? = []
                    for singleJsonItem in JSON(response.data!)["messages"] {
                        messages!.append(self.makeMessage(jsonItem: singleJsonItem.1))
                    }
                    completed(true, messages)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getMessageById(_id: String?, completed: @escaping (Bool, Message?) -> Void ) {
        AF.request(Constants.serverUrl + "/message/by-id",
                   method: .get,
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let message = self.makeMessage(jsonItem: jsonData["message"])
                    completed(true, message)
                case let .failure(error):
                    print(error)
                    completed(false, nil)
                }
            }
    }
    
    func addMessage(message: Message, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/message/",
                   method: .post,
                   parameters: [
                    "seen": message.seen!,
                    "seenDate": message.seenDate!,
                    "sentDate": message.sentDate!,
                   // "chat": message.chat!._id!
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
    
    func editMessage(message: Message, completed: @escaping (Bool) -> Void ) {
        //   "chat": message.chat!._id!
        AF.request(Constants.serverUrl + "/message/",
                   method: .put,
                   parameters: [
                    "_id": message._id!,
                    "seen": message.seen!,
                    "seenDate": message.seenDate!,
                    "sentDate": message.sentDate!,
                
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
    
    func deleteMessage(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/message/",
                   method: .delete,
                   parameters: [
                    "_id": _id!
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
    
    func makeMessage(jsonItem: JSON) -> Message {
        // chat: makeChat(jsonItem: jsonItem["chat"])
        Message(
            _id: jsonItem["_id"].stringValue,
            seen: jsonItem["seen"].boolValue,
            seenDate: Date(), //jsonItem["seenDate"].stringValue,
            sentDate: Date() //jsonItem["sentDate"].stringValue  
        )
    }
    
    func makeChat(jsonItem: JSON) -> Chat {
        // TODO
        return Chat()
    }
}
