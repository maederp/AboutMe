//
//  MailComposer.swift
//  AboutMe
//
//  Created by Peter Mäder on 29.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import MessageUI

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        mailComposeVC.setToRecipients(["peter@maeder.info"])
        mailComposeVC.setSubject("AboutMe - App - Message")
        mailComposeVC.setMessageBody("Dear Peter, ... please add your text here ...", isHTML: true)
        
        return mailComposeVC
    }

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
