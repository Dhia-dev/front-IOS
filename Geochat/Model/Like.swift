//
//  Like.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Like: Encodable {
    
    var _id: String?
    var clickDate: Date?
    var seen: Bool?
    
    var liker: User?
    var liked: User?
}
