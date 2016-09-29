//
//  LinkedInViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 26.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit

class AboutMeViewController: UIViewController {
    
    // MARK: Outlets & Properties
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    
    private let messageComposer = MessageComposer()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoImageView.image = UIImage(named: "PhotoStack")
        photoImageView.contentMode = .center
        
        FireStorageClient.sharedInstance().getImage(title: "PeterMaeder-Portrait.jpg") { (image , error) in
            if error == nil{
                performUIUpdatesOnMain{
                    self.photoImageView.image = image
                    self.photoImageView.contentMode = .scaleAspectFit
                }
            }
        }
        
        let buttons : [UIButton] = [messageButton, phoneButton, mailButton]
        roundButtonCorners(buttons: buttons, radius: 10)
        
    }
    
    // MARK: Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.white
        
        if !messageComposer.canSendMessage(){
            print("i can send sms/imessages")
            
            let messageComposerVC = messageComposer.configureMessageComposeViewController()
            present(messageComposerVC, animated: true, completion: nil)
            
        }else{ //Show alert message if sending messages isn't available
            showOKAlert(title: "Alert - Send Message unavailable", actionText: "OK", message: "Sending Messages is not supported on your device")
        }
    }
    
    @IBAction func initiatePhoneCall(_ sender: UIButton) {
        print("initiatePhoneCall")
        sender.backgroundColor = UIColor.white
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        print("sendMail")
        sender.backgroundColor = UIColor.white
    }
    
    @IBAction func buttonReleased(_ sender: UIButton) {
        let blueColor = UIColor.init(red: 25, green: 87, blue: 127, alpha: 0.7)
        sender.backgroundColor = blueColor
    }

    // MARK: Utilities
    private func roundButtonCorners(buttons: [UIButton], radius: Int){
        
        for button in buttons{
            button.layer.cornerRadius = CGFloat(radius)
        }
    }
    
    private func showOKAlert(title: String, actionText: String, message: String){
    
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
    
        present(alertController, animated: true, completion: nil)
    }
}
