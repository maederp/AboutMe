//
//  GithubDetailViewController.swift
//  AboutMe
//
//  Created by Peter Mäder on 11.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import UIKit

class GithubDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var githubWebView: UIWebView!
    @IBOutlet weak var githubWebViewActivityIndicator: UIActivityIndicatorView!
    
    var webViewURL : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        githubWebView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Create Return/Done Navigation Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(FlickrDetailViewController.dismissViewController))

        let githubURL = URL(string: webViewURL)!
        let urlRequest = URLRequest(url: githubURL)
        githubWebView.loadRequest(urlRequest)
        
    }
    
    // MARK: Webview Delegate session
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        performUIUpdatesOnMain {
            self.githubWebViewActivityIndicator.startAnimating()
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        performUIUpdatesOnMain {
            self.githubWebViewActivityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showOKAlert(title: "Cannot load page", actionText: "OK", message: "Website load currently not possible")
    }
    
    
    
    // MARK: Helpers
    func dismissViewController() -> Void {
        _ = navigationController?.popToRootViewController(animated: true)
    }

    private func showOKAlert(title: String, actionText: String, message: String){
        
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
