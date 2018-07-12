//
//  NewsListAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class NewsListModuleAssembly {
    
    func buildNewsListModule(_ completion: (UIViewController?, NewsListModuleInput?) -> Void) {
        
        // Creating module components
        let viewController = UIStoryboard(name: NewsListStoryboardName, bundle: nil).instantiateViewController(withIdentifier: NewsListViewControllerStoryboardIdentifier)
        let presenter = NewsListPresenter()
        
        guard let moduleViewController = viewController as? NewsListViewController else {
            completion(nil, nil)
            return
        }
        
        // Inject properties
        moduleViewController.output = presenter
        presenter.view = moduleViewController
        presenter.router = moduleViewController
        
        completion(moduleViewController, presenter)
        
    }
    
}
