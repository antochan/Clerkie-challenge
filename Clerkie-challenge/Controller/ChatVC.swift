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
import FirebaseStorage

class ChatVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var quickChatCollectionView: UICollectionView!
    @IBOutlet weak var chatTopView: UIView!
    
    var messages : [Message] = [Message]()
    
    var buttonTextArray = ["Finincial Breakdown", "Daily Spending", "Weekly Spending", "Yearly Spending", "Annual Save", "Deposits"]
    
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
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.chatTableView.backgroundView = bgView
        
        retrieveMessages()
        configureInputBar()
        
        quickChatCollectionView.delegate = self
        quickChatCollectionView.dataSource = self
        
        chatTopView.dropShadow()
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
    
    func configureInputBar() {
        let leftButton  = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 40))
        
        leftButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        leftButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        rightButton.setImage(#imageLiteral(resourceName: "send"), for: .normal)
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
                self.textInputBar.isUserInteractionEnabled = false
                self.quickChatCollectionView.isUserInteractionEnabled = false
                //function from Clerkie Bot
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.clerkieBotMessage(userInputString: self.textInputBar.text)
                    self.textInputBar.text = ""
                    self.textInputBar.isUserInteractionEnabled = true
                    self.quickChatCollectionView.isUserInteractionEnabled = true
                })
                
            } else {
                self.displayAlert(title: "An error occured!", message: "try sending message again later!")
            }
        }
    }
    
    func clerkieBotMessage(userInputString: String) {
        var messageToSend = ""
        if userInputString.containsIgnoringCase(find: "financial") {
            messageToSend = "Your current financial situation looks solid! You spent $200 this month and you you kept a good rate for saving $10,000 this year!"
        } else if userInputString.containsIgnoringCase(find: "Hello") {
            messageToSend = "Hey! Hope your doing well today!! Ask me anything, I am a smart financial advisor!"
        } else if userInputString.containsIgnoringCase(find: "Daily") {
            messageToSend = "On average, your spending $45 per day. You are currently spending above your financial goals, try to spend less on entertainment!"
        } else if userInputString.containsIgnoringCase(find: "Weekly") {
            messageToSend = "On average, your spending $312.42 per day. You are currently spending above your financial goals, try to spend less on entertainment!"
        } else if userInputString.containsIgnoringCase(find: "Yearly") {
            messageToSend = "On average, your spending $34,021.52 per day. You are currently spending above your financial goals. 5% student loans, 24.2% housing, 12% entertainment, 16% food & essentials!"
        } else if userInputString.containsIgnoringCase(find: "Save") {
            messageToSend = "Your goal is to save at least 60 dollars a week at your currently income rate. You are over spending on entertainment and will only save $2 at this week"
        } else if userInputString.containsIgnoringCase(find: "Deposit") {
            messageToSend = "You recieved your last paycheck/deposit on March 3rd, 2018 3:22pm of $1,200 dollars. Keep making that MULA"
        } else {
            messageToSend = "I am Clerkie! Your very own financial chat bot aid. I'm smarter than most humans too so don't worry, I'll be of help :)"
        }
        
        
        ChatServices.instance.sendMessage(sender: "ClerkieBot", message: messageToSend, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
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
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    @IBAction func analyticsDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AnalyticsVC") as! AnalyticsVC
        present(vc, animated: true, completion: nil)
    }
    

}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        //TODO: convert URL into image

        cell.messageLabel.text = self.messages[indexPath.row].Message
        
        
        if messages[indexPath.row].Sender != Auth.auth().currentUser?.email {
            cell.messageBubble.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            cell.messageLabel.textColor = .black
            cell.leftConstraint.constant = 2
            cell.rightConstraint.constant = -60
        } else {
            cell.messageBubble.backgroundColor = UIColor.FlatColor.Blue.NavyBlue
            cell.messageLabel.textColor = .white
            cell.leftConstraint.constant = 68
            cell.rightConstraint.constant = 2
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action:
        Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if (action.description == "copy:") {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if (action.description == "copy:") {
            //...
        }
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var frame = cell.contentView.frame
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            frame.origin.y = -10
            cell.contentView.frame = frame
        }) { (success) in
            frame.origin.y = 0
            cell.contentView.frame = frame
        }
        
    }
    
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                    ChatServices.instance.sendMessage(sender: (Auth.auth().currentUser?.email)!, message: downloadURL.absoluteString, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
                        return
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonTextArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
        
        cell.smartChatButton.setTitle(buttonTextArray[indexPath.row], for: .normal)
        
        cell.smartChatButton.tag = indexPath.row
        cell.smartChatButton.addTarget(self, action: #selector(quickChatTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func quickChatTapped(sender : UIButton){
        let message = buttonTextArray[sender.tag]

        ChatServices.instance.sendMessage(sender: (Auth.auth().currentUser?.email)!, message: message, chatRoom: (Auth.auth().currentUser?.uid)!) { (success) in
            if success {
                self.textInputBar.isUserInteractionEnabled = false
                self.quickChatCollectionView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.clerkieBotMessage(userInputString: message)
                    self.textInputBar.isUserInteractionEnabled = true
                    self.quickChatCollectionView.isUserInteractionEnabled = true
                })
                
            } else {
                print("error!")
            }
        }
    }
    
    
}
