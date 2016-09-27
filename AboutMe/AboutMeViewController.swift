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
    }
    
}
