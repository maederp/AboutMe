//
//  MessageComposer.swift
//  AboutMe
//
//  Created by Peter Mäder on 29.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    func canSendMessage() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func configureMessageComposeViewController() -> MFMessageComposeViewController {
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        
        messageComposeVC.recipients = ["+41796618780"]
        messageComposeVC.body = "Hi Peter - downloaded your app. Please respond!"
        
        return messageComposeVC
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: false, completion: nil)
    
    }
}
