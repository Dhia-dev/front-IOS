//
//  User.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct User: Encodable {
    
    internal init(_id: String? = nil, email: String? = nil, password: String? = nil, firstname: String? = nil, lastname: String? = nil, age: Int? = nil,
                  //testing
                  latitude: Double? = nil, longitude: Double? = nil,
                  sexe: String? = nil, location: String? = nil, isVerified: Bool? = nil) {
        self._id = _id
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.age = age
        self.sexe = sexe
        self.location = location
        self.isVerified = isVerified
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // added for testing
    
    var latitude: Double?
    var longitude: Double?
    //
    var _id: String?
    var email: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var age: Int?
    var sexe: String?
    var location: String?
    var isVerified: Bool?
    
}
