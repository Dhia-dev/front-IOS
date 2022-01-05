//
//  Payment.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Payment: Encodable {
    
    var _id: String?
    var description: String?
    var amount: Float?
    var date: Date?
    var user: User?
    
}
