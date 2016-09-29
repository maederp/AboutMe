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
        print("sendMessage")
        sender.backgroundColor = UIColor.white
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
        sender.backgroundColor = UIColor.gray
//        sender.backgroundColor = UIColor.init(red: CGFloat(25), green: CGFloat(87), blue: CGFloat(127), alpha: CGFloat(0.7))
    }

    // MARK: Utilities
    private func roundButtonCorners(buttons: [UIButton], radius: Int){
        
        for button in buttons{
            button.layer.cornerRadius = CGFloat(radius)
        }
    }
}
