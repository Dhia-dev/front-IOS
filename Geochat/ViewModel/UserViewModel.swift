//
//  UserViewModel.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class UserViewModel {
    
    func getAllUsers(completed: @escaping (Bool, [User]?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/",
                   method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var users : [User]? = []
                    for singleJsonItem in JSON(response.data!)["users"] {
                        users!.append(self.makeUser(jsonItem: singleJsonItem.1))
                    }
                    completed(true, users)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func signUp(user: User, completed: @escaping (Bool) -> Void ) {
        print(user)
        
        AF.request(Constants.serverUrl + "/user/signUp",
                   method: .post,
                   parameters: [
                    "email": user.email!,
                    "password": user.password!,
                    "firstname": user.firstname!,
                    "lastname": user.lastname!,
                    "age": user.age!,
                    "sexe": user.sexe!,
                    "location": user.location!,
                    "isVerified": user.isVerified!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func login(email: String, password: String, completed: @escaping (Bool, Any?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/login",
                   method: .post,
                   parameters: [
                    "email": email,
                    "password": password
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    UserDefaults.standard.setValue(jsonData["token"].stringValue, forKey: "userToken")
                    UserDefaults.standard.setValue(user._id, forKey: "userId")
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getUserFromToken(userToken: String, completed: @escaping (Bool, User?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/getUserFromToken",
                   method: .post,
                   parameters: ["userToken": userToken],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    print("User from token :")
                    print(user)
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func loginWithSocialApp(email: String, firstname: String, lastname: String, completed: @escaping (Bool, User?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/loginWithSocialApp",
                   method: .post,
                   parameters: [
                    "email": email,
                    "firstname": firstname,
                    "lastname": lastname
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    
                    print("this is the new token value : " + jsonData["token"].stringValue)
                    UserDefaults.standard.setValue(jsonData["token"].stringValue, forKey: "userToken")
                    UserDefaults.standard.setValue(user._id, forKey: "userId")
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func resendConfirmation(email: String, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/resendConfirmation",
                   method: .post,
                   parameters: ["email": email])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func forgotPassword(email: String, resetCode: String, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/forgotPassword",
                   method: .post,
                   parameters: ["email": email, "resetCode": resetCode])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editPassword(email: String?, newPassword: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/editPassword",
                   method: .put,
                   parameters: [
                    "email": email!,
                    "newPassword": newPassword!
                   ])
            .response { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editProfile(user: User, completed: @escaping (Bool) -> Void ) {
        print(user)
        AF.request(Constants.serverUrl + "/user/editProfile",
                   method: .put,
                   parameters: [
                    "_id" : user._id!,
                    "email": user.email!,
                    "firstname": user.firstname!,
                    "lastname": user.lastname!,
                    "sexe": user.sexe!,
                    "age": user.age!,
                    "location": user.location!
                   ])
            .response { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    
    func makeUser(jsonItem: JSON) -> User {
        User(
            _id: jsonItem["_id"].stringValue,
            email: jsonItem["email"].stringValue,
            password: jsonItem["password"].stringValue,
            firstname: jsonItem["firstname"].stringValue,
            lastname: jsonItem["lastname"].stringValue,
            age: jsonItem["age"].intValue,
            latitude: jsonItem["latitude"].doubleValue,
            longitude: jsonItem["longitude"].doubleValue,
            sexe: jsonItem["sexe"].stringValue,
            location: jsonItem["location"].stringValue,
            isVerified: jsonItem["isVerified"].boolValue
            
            
            
        )
    }
    
    func setPosition(email: String, latitude: Double, longitude: Double, clear: Bool, completed: @escaping (Bool) -> Void ) {
        
        AF.request(Constants.serverUrl + "/user/setPosition",
                   method: .put,
                   parameters: [
                    "email": email,
                    "latitude": latitude,
                    "longitude" : longitude,
                    "clear" : clear
                   ],
                   encoding: JSONEncoding.default)
            .response { response in
                switch response.result {
                case .success:
                    print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
}
