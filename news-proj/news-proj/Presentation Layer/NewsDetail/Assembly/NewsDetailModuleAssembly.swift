//
//  NewsDetailAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class NewsDetailModuleAssembly {
    
    func buildNewsDetailModule(_ completion: (UIViewController?, NewsDetailModuleInput?) -> Void) {
        
        // Creating module components
        let viewController = UIStoryboard(name: NewsDetailStoryboardName, bundle: nil).instantiateViewController(withIdentifier: NewsDetailViewControllerStoryboardIdentifier)
        let presenter = NewsDetailPresenter()
        let newsDetailService = NewsDetailServiceAssembly().buildNewsDetailService(delegate: presenter)
        
        guard let moduleViewController = viewController as? NewsDetailViewController else {
            completion(nil, nil)
            return
        }
        
        // Inject properties
        moduleViewController.output = presenter
        presenter.view = moduleViewController
        presenter.router = moduleViewController
        presenter.newsDetailService = newsDetailService
        
        completion(moduleViewController, presenter)
        
    }
    
}
