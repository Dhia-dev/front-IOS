//
//  PaymentViewModel.swift
//  Geochat
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class PaymentViewModel {
    
    func getAllPayment(completed: @escaping (Bool, [Payment]?) -> Void ) {
        AF.request(Constants.serverUrl + "/payment/",
                   method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var payments : [Payment]? = []
                    for singleJsonItem in JSON(response.data!)["payments"] {
                        payments!.append(self.makePayment(jsonItem: singleJsonItem.1))
                    }
                    completed(true, payments)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getPaymentById(_id: String?, completed: @escaping (Bool, Payment?) -> Void ) {
        AF.request(Constants.serverUrl + "/payment/by-id",
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
                    let payment = self.makePayment(jsonItem: jsonData["payment"])
                    completed(true, payment)
                case let .failure(error):
                    print(error)
                    completed(false, nil)
                }
            }
    }
    
    func addPayment(payment: Payment, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/payment/",
                   method: .post,
                   parameters: [
                    "description": payment.description!,
                    "amount": payment.amount!,
                    "date": payment.date!,
                    "user": payment.user!._id!
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
    
    func editPayment(payment: Payment, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/payment/",
                   method: .put,
                   parameters: [
                    "_id": payment._id!,
                    "description": payment.description!,
                    "amount": payment.amount!,
                    "date": payment.date!,
                    "user": payment.user!._id!
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
    
    func deletePayment(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/payment/",
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
    
    func makePayment(jsonItem: JSON) -> Payment {
        Payment(
            _id: jsonItem["_id"].stringValue,
            description: jsonItem["dateEntre"].stringValue,
            amount: jsonItem["dateEntre"].floatValue,
            date: Date(),
            user: makeUser(jsonItem: jsonItem["user"])
        )
    }
    
    func makeUser(jsonItem: JSON) -> User {
        // TODO
        return User()
    }
}
