//
//  MessageTableViewCell.swift
//  Clerkie-challenge
//
//  Created by Antonio Chan on 2018/9/21.
//  Copyright © 2018 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewMessage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
