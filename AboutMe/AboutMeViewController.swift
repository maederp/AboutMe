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
    @IBOutlet weak var photoReloadButton: UIButton!
    @IBOutlet weak var photoImageActivityViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    private let messageComposer = MessageComposer()
    private let mailComposer = MailComposer()
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoImageView.image = UIImage(named: "PhotoStack")
        photoImageView.contentMode = .center
        
        // Mark: get AboutMe Image from Disk - otherwise download from Firebase
        let aboutMeImage = getAboutMeImageFromDisk(filename: "PeterMaeder-Portrait.jpg")
        
        if aboutMeImage != nil{
            performUIUpdatesOnMain{
                self.photoImageView.image = aboutMeImage
                self.photoImageView.contentMode = .scaleAspectFit
            }
        }else{
            performUIUpdatesOnMain {
                self.photoImageActivityViewIndicator.startAnimating()
            }
            
            FireStorageClient.sharedInstance().getImage(title: "PeterMaeder-Portrait.jpg") { (image , error) in
                if error == nil{
                    performUIUpdatesOnMain{
                        self.photoImageView.image = image
                        self.photoImageView.contentMode = .scaleAspectFit
                        _ = self.saveAboutMeImageToDisk(filename: "PeterMaeder-Portrait.jpg", image: image!)
                        self.photoImageActivityViewIndicator.stopAnimating()
                    }
                }else{
                    performUIUpdatesOnMain{
                        self.photoImageActivityViewIndicator.stopAnimating()
                        self.showOKAlert(title: "Alert - No Connection", actionText: "OK", message: "Currently unable to download the AboutMe Image. Please retry later")
                    }
                }
            }
        }
        
        let buttons : [UIButton] = [messageButton, phoneButton, mailButton]
        roundButtonCorners(buttons: buttons, radius: 10)
        
    }
    
    // MARK: Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.white
        
        if messageComposer.canSendMessage(){
            
            let messageComposerVC = messageComposer.configureMessageComposeViewController()
            present(messageComposerVC, animated: true, completion: nil)
            
        }else{ //Show alert message if sending messages isn't available
            showOKAlert(title: "Alert - Send Message unavailable", actionText: "OK", message: "Sending Messages is not supported on your device")
        }
    }
    
    @IBAction func initiatePhoneCall(_ sender: UIButton) {

        sender.backgroundColor = UIColor.white
        
        if let phoneCallURL:URL = URL(string: "tel://+41796618780") {
            if (UIApplication.shared.canOpenURL(phoneCallURL)) {
                UIApplication.shared.open(phoneCallURL, options: [:] , completionHandler: nil)
            }
        }
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.white
        
        if mailComposer.canSendMail(){
            
            let mailComposerVC = mailComposer.configureMailComposeViewController()
            present(mailComposerVC, animated: true, completion: nil)
            
        }else{
            showOKAlert(title: "Alert - Send Mail unavailable", actionText: "OK", message: "Sending Mails is not supported on your device")
        }
        
    }
    
    @IBAction func reloadPhotoButtonPressed(_ sender: AnyObject) {
        
        performUIUpdatesOnMain {
            self.photoImageView.image = UIImage(named: "PhotoStack")
            self.photoImageView.contentMode = .center
            self.photoImageActivityViewIndicator.startAnimating()
        }
        
        FireStorageClient.sharedInstance().getImage(title: "PeterMaeder-Portrait.jpg") { (image , error) in
            if error == nil{
                performUIUpdatesOnMain{
                    self.photoImageView.image = image
                    self.photoImageView.contentMode = .scaleAspectFit
                    self.photoImageView.reloadInputViews()
                    _ = self.saveAboutMeImageToDisk(filename: "PeterMaeder-Portrait.jpg", image: image!)
                    self.photoImageActivityViewIndicator.stopAnimating()
                }
            }else{
                performUIUpdatesOnMain{
                    self.photoImageView.image = UIImage(named: "PhotoStack")
                    self.showOKAlert(title: "Alert - No Connection", actionText: "OK", message: "Currently unable to download the AboutMe Image. Please retry later")
                }
            }
        }
    }
    
    
    @IBAction func buttonReleased(_ sender: UIButton) {
        sender.backgroundColor = UIColor.lightGray
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
    
    private func getAboutMeImageFromDisk(filename: String) -> UIImage?{
        
        var aboutMeImage : UIImage? = nil
        
        let fm = FileManager.default
        
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return nil
        }
        
        let fileURL = docUrl.appendingPathComponent(filename)

        if let data = NSData(contentsOf: fileURL){
            aboutMeImage = UIImage(data: data as Data)!
        }
        
        return aboutMeImage
    }
    
    private func saveAboutMeImageToDisk(filename: String, image: UIImage) -> Bool {
        
        var success = false
        
        let fm = FileManager.default
        
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return success
        }
        
        let fileURL = docUrl.appendingPathComponent(filename)
        let imageData = UIImageJPEGRepresentation(image, 0)
            
        if let data = imageData{
            do{
                try data.write(to: fileURL)
                success = true
            }catch let error as NSError{
                print("failed to save aboutMeImage. Error: \(error.description)")
            }
        }
        
        return success
    }
}
