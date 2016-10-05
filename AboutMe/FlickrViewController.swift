//
//  FlickrViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit

class FlickrViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var flickrPhotos: UICollectionView!

    // CollectionView Index Paths
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!

    
    // MARK: View Lifecycle Section
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        FlickrClient.sharedInstance().getPhotosBy(userID: "147944923@N02", completionHandler: {(data, error) in
        
            if error == nil{
                
                print("Flickr Data: \(data!)")
                
            }else{
                self.showOKAlert(title: "Alert - Flickr Data unavailable", actionText: "OK", message: "Cannot load Flickr Data. Please retry later")
            }
        })
    }
    
    
    // MARK: Collection View Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //let sectionInfo = fetchedResultsController.sections![section]
        
        //return sectionInfo.numberOfObjects
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "FlickrCollectionViewCell"
        
        let cell = flickrPhotos.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FlickrCollectionViewCell
        
        cell.imageView.image = UIImage(named: "PhotoPlaceholder")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: Utilities & Helpers
    private func showOKAlert(title: String, actionText: String, message: String){
        
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
