//
//  NewsDetailViewController.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, ErrorAlertPresenter {
    
    var output: NewsDetailViewOutput!
    
    @IBOutlet fileprivate weak var webViewContainerView: UIView!
    fileprivate weak var webView: WKWebView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {

        super.viewDidLoad()

        output.didTriggerViewReadyEvent()

    }

}

// MARK: - NewsDetailViewInput
extension NewsDetailViewController: NewsDetailViewInput {
    
    func setupInitialState() {
        
        // Set up web view
        setupWebView()
        
    }

    func configure(screenName: String) {
        navigationItem.title = screenName
    }
    
    func configure(htmlText: String) {
        webView.loadHTMLString(htmlText, baseURL: nil)
    }

    func showErrorMessage(_ message: String) {
        showAlert(errorMessage: message)
    }
    
}

// MARK: - Private
extension NewsDetailViewController {
    
    fileprivate func setupWebView() {
        
        let configuration = WKWebViewConfiguration()
        let webKitView = WKWebView(frame: .zero, configuration: configuration)
        webKitView.translatesAutoresizingMaskIntoConstraints = false
        
        webViewContainerView.addSubview(webKitView)
        
        let views = ["webView": webKitView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webView]-0-|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        
        webView = webKitView
        
    }
    
}

// MARK: - NewsDetailModuleRouting
extension NewsDetailViewController: NewsDetailModuleRouting {
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
