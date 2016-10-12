//
//  GithubViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 29.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GithubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var githubTable: UITableView!
    
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
        
        //Hide Navigation Bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        githubTable.delegate = self
        githubTable.dataSource = self
        
        //check if any GithubRepos are fetched from CoreData - if 0, then load them from Github
        if fetchedResultsController.fetchedObjects?.count == 0 {
            
            GithubClient.sharedInstance().getUserRepoData("maederp", completionHandler: { (data, error) in
                if error == nil{
                    performUIUpdatesOnMain {
                        self.githubTable.reloadData()
                    }
                    
                }else{
                    
                    self.showOKAlert(title: "Alert - Github Data unavailable", actionText: "OK", message: "Cannot load Github Data. Please retry later")
                }
            })
            
        }
    }
    
    
    // MARK: CoreData Section
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GithubRepository")
        
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        githubTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        githubTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            githubTable.deleteRows(at: [indexPath!], with: .fade)
            
        case .insert:
            githubTable.insertRows(at: [newIndexPath!], with: .fade)
            
        case .update:
            let cell = githubTable.cellForRow(at: indexPath!)
            let repo = controller.object(at: indexPath!) as! GithubRepository
            cell?.textLabel?.text = repo.name
            cell?.detailTextLabel?.text = repo.htmlURL
            
        case .move:
            githubTable.deleteRows(at: [indexPath!], with: .fade)
            githubTable.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            githubTable.deleteSections(IndexSet.init(integer: sectionIndex), with: .fade)
        case .insert:
            githubTable.insertSections(IndexSet.init(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    
    // MARK: TableView Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GithubCell", for: indexPath)
        
        let repo = fetchedResultsController.fetchedObjects?[indexPath.row] as! GithubRepository
        
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = "last update: \(repo.pushedAt!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let githubRepo = fetchedResultsController.object(at: indexPath) as? GithubRepository
        
        performUIUpdatesOnMain {
            if let githubDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "GithubDetailViewController") as? GithubDetailViewController{
                
                githubDetailVC.webViewURL = githubRepo?.htmlURL
                self.navigationController?.pushViewController(githubDetailVC, animated: true)
            }
        }
    }
    
    // MARK: Supporting Section
    private func showOKAlert(title: String, actionText: String, message: String){
        
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
