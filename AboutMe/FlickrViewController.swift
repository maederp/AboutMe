//
//  FlickrViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlickrViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var flickrPhotos: UICollectionView!

    // CollectionView Index Paths
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!

    // NSManagedObject Context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // MARK: View Lifecycle Section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: fetch Photos from CoreData
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print(error)
        }
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        //pick Flickr UserID from Info.plist
        let flickrUserID = Bundle.main.object(forInfoDictionaryKey: "FlickrUserID") as! String
        
    
        //check if any Photo is fetched from CoreData - if 0, then load them from Flickr
        if fetchedResultsController.fetchedObjects?.count == 0 {
        
            FlickrClient.sharedInstance().getPhotosBy(userID: flickrUserID, completionHandler: {(data, error) in
                
                if error == nil{
                    print("Flickr Data: \(data!)")
                }else{
                    self.showOKAlert(title: "Alert - Flickr Data unavailable", actionText: "OK", message: "Cannot load Flickr Data. Please retry later")
                }
            })
            
        }
        
    }
    
    
    // MARK: Collection View Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "FlickrCollectionViewCell"
        
        let cell = flickrPhotos.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FlickrCollectionViewCell
        
        performUIUpdatesOnMain {
            cell.imageView.image = UIImage(named: "PhotoPlaceholder")
            cell.imageView.contentMode = .center
            
            if let photo = self.fetchedResultsController.fetchedObjects?[indexPath.item] as? Photo {
                if photo.image != nil{
                    cell.imageView.contentMode = .scaleAspectFill
                    cell.imageView.image = UIImage(data: photo.image as! Data)
                } else{
                    cell.imageViewActivityIndicator.startAnimating()
                    
                    FlickrClient.sharedInstance().getFotoForId(photo.id){ (image, error) in
                        
                        if image != nil {
                            
                            photo.image = image as? NSData
                            CoreDataStackManager.sharedInstance().saveContext()
                            
                            cell.imageView.contentMode = .scaleAspectFill
                            cell.imageView.image = UIImage(data: photo.image as! Data)
                            cell.imageViewActivityIndicator.stopAnimating()
                            
                        } else {
                            cell.imageViewActivityIndicator.stopAnimating()
                        }
                    }
                }
            } else {
                
                print("irgend ein Problem")
                
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = fetchedResultsController.object(at: indexPath) as? Photo
        
        performUIUpdatesOnMain {
            if let imageDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FlickrDetailViewController") as? FlickrDetailViewController{
            
                imageDetailVC.image = UIImage(data: (photo?.image as? Data)!)
                self.navigationController?.pushViewController(imageDetailVC, animated: true)
            }
        }
    }
    
    // MARK: CoreData Section
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Photo")
        
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    // MARK: FetchedResultsController Delegate Section
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
            
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
        case .delete:
            deletedIndexPaths.append(indexPath!)
        case .update:
            updatedIndexPaths.append(indexPath!)
        case .move:
            print("Move an item. Not implemented in this app.")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.flickrPhotos.performBatchUpdates( {() -> Void in
            self.flickrPhotos.insertItems(at: self.insertedIndexPaths)
            self.flickrPhotos.deleteItems(at: self.deletedIndexPaths)
            self.flickrPhotos.reloadItems(at: self.updatedIndexPaths)
            }, completion: nil)
    
    }

    
    // MARK: Utilities & Helpers
    
    private func showOKAlert(title: String, actionText: String, message: String){
        
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
