//
//  Message.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Message: Encodable {
    
    
    var _id: String?
    
    var seen: Bool?
    var text: String?
    
    var seenDate: Date?
    var sentDate: Date?
    // var chat: Chat?
    
}
