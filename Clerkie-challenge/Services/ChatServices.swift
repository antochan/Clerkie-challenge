//
//  ChatServices.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/21.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class ChatServices {
    
    static let instance = ChatServices()
    
    func sendMessage(sender: String, message: String, chatRoom: String, completion: @escaping CompletionHandler) {
        let messageDB = Database.database().reference().child(chatRoom)
        
        let messageDictionary = ["Sender": sender,
                                 "Message": message]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error)
                completion(false)
            } else {
                print("sent message!")
                completion(true)
            }
        }
    }
    
}
