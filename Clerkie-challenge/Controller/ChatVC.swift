//
//  ChatVC.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/20.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var messages : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpNavigationBar()
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.chatTableView.backgroundView = bgView
        
        retrieveMessages()
    
    }
    
    func setUpTableView() {
        chatTableView.keyboardDismissMode = .onDrag
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        chatTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        chatTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.FlatColor.Blue.PastelBlue
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        ChatServices.instance.sendMessage(sender: (Auth.auth().currentUser?.email)!, message: messageTextField.text!, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in

            if success {
                //function from Clerkie Bot
                self.clerkieBotMessage()
                self.messageTextField.text = ""
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                
            } else {
                self.displayAlert(title: "An error occured!", message: "try sending message again later!")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
    }
    
    func clerkieBotMessage() {
        ChatServices.instance.sendMessage(sender: "ClerkieBot", message: "I am Clerkie!", chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
            return
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child((Auth.auth().currentUser?.uid)!)
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["Message"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.Message = text
            message.Sender = sender
            
            self.messages.append(message)
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                
                if self.messages.count != 0 {
                    self.chatTableView.scrollToRow(at: IndexPath(item:self.messages.count-1, section: 0), at: .bottom, animated: false)
                }
            }
        }
        
    }

}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = messages[indexPath.row].Message
        
        if messages[indexPath.row].Sender != Auth.auth().currentUser?.email as String! {
            cell.messageBubble.backgroundColor = UIColor.FlatColor.Yellow.PastelYellow
            cell.messageLabel.textColor = .black
            cell.leftConstraint.constant = 2
            cell.rightConstraint.constant = -60
        } else {
            cell.messageBubble.backgroundColor = UIColor.FlatColor.Blue.PastelBlue
            cell.messageLabel.textColor = .white
            cell.leftConstraint.constant = 68
            cell.rightConstraint.constant = 2
        }

        return cell
    }
    
    
}
