//
//  ChatVC.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/20.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase
import ALTextInputBar

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    var messages : [Message] = [Message]()
    
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textInputBar.frame.size.width = view.bounds.size.width
    }
    
    // This is how we attach the input bar to the keyboard
    override var inputAccessoryView: UIView? {
        get {
            return keyboardObserver
        }
    }
    
    // Another ingredient in the magic sauce
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpNavigationBar()
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.chatTableView.backgroundView = bgView
        
        retrieveMessages()
        configureInputBar()
    
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
    
    func configureInputBar() {
        let leftButton  = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        
        leftButton.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
        leftButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        rightButton.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        rightButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        keyboardObserver.isUserInteractionEnabled = false
        
        textInputBar.showTextViewBorder = true
        textInputBar.leftView = leftButton
        textInputBar.rightView = rightButton
        textInputBar.frame = CGRect(x: 0, y: view.frame.size.height - textInputBar.defaultHeight, width: view.frame.size.width, height: textInputBar.defaultHeight)
        textInputBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        view.addSubview(textInputBar)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        textInputBar.endEditing(true)
        
        ChatServices.instance.sendMessage(sender: (Auth.auth().currentUser?.email)!, message: textInputBar.text!, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in

            if success {
                //function from Clerkie Bot
                self.clerkieBotMessage()
                self.textInputBar.text = ""
                
            } else {
                self.displayAlert(title: "An error occured!", message: "try sending message again later!")
            }
        }
    }
    
    func clerkieBotMessage() {
        ChatServices.instance.sendMessage(sender: "ClerkieBot", message: "I am Clerkie! Your very own financial chat bot aid. I'm smarter than most humans too so don't worry, I'll be of help :)", chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
            return
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do
        {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.present(controller, animated: true, completion: nil)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
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
        
        //TODO better conditional for images
//        if messages[indexPath.row].Message.count > 200 {
//                cell.imageViewMessage.image = #imageLiteral(resourceName: "picture")
//                cell.messageLabel.text = ""
//        } else {
            cell.messageLabel.text = messages[indexPath.row].Message
//        }
        
        
        if messages[indexPath.row].Sender != Auth.auth().currentUser?.email {
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

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
  
        let imageData: Data? = UIImageJPEGRepresentation(image, 0.1)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        print(imageStr)
        
        ChatServices.instance.sendMessage(sender: (Auth.auth().currentUser?.email)!, message: imageStr, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
