//
//  FlickrDetailViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 07.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit

class FlickrDetailViewController: UIViewController {
    
    // MARK: Outlets & Properties
    @IBOutlet weak var FlickrDetailImageView: UIImageView!
    
    var image : UIImage!
    
    // MARK: View Lifecycle Section
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Create Return/Done Navigation Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(FlickrDetailViewController.dismissViewController))
        
        FlickrDetailImageView.image = image
        
    }
    
    func dismissViewController() -> Void {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
