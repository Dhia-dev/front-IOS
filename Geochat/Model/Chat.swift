//
//  Chat.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Chat: Encodable {
    
    // list of
    // sendeMsgs
    // Reciever Msgs
    // list
    
    var _id: String?
    // adding
    var senderMsgs : [Message] = []
    var recieverMsgs : [Message] = []
    var date: Date?
    var lastMessage: String?
    
    var sender: User?
    var receiver: User?
    
}
