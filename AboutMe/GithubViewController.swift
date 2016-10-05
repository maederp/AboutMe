//
//  GithubViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 29.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit

class GithubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var githubTable: UITableView!
    
    var githubRepositoryData = [String]()
    
    // MARK: View Lifecycle Section
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        githubTable.delegate = self
        githubTable.dataSource = self
        
        GithubClient.sharedInstance().getUserRepoData("maederp", completionHandler: { (data, error) in
            if error == nil{
                self.githubRepositoryData = data as! [String]
                print("githubRepository Data: \(self.githubRepositoryData)")
                
                performUIUpdatesOnMain {
                    self.githubTable.reloadData()
                }
                
            }else{
                self.showOKAlert(title: "Alert - Github Data unavailable", actionText: "OK", message: "Cannot load Github Data. Please retry later")
            }
        })
    }
    
    // MARK: TableView Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubRepositoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GithubCell", for: indexPath)
        
        cell.textLabel?.text = githubRepositoryData[indexPath.row]
        
        return cell
    }
    
    // MARK: Supporting Section
    private func showOKAlert(title: String, actionText: String, message: String){
        
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
