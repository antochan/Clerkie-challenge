//
//  AuthServices.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/20.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AuthServices {
    
    static let instance = AuthServices()
    
    func registerUserWithEmail(email: String, password: String, completion: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "Error!")
                completion(false)
            } else {
                print("successfully registered a user with email!")
                completion(true)
            }
        }
    }
    
    func loginUserWithEmail(email: String, password: String, completion: @escaping CompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "Error!")
                completion(false)
            } else {
                print("succesfully logged user in!")
                completion(true)
            }
        }
    }
    
}
