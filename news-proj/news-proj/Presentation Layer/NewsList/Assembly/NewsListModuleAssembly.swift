//
//  NewsListAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class NewsListModuleAssembly {
    
    func buildNewsListModule(_ completion: (UIViewController, NewsListModuleInput) -> Void) {
        
        // Creating module components
        let viewController = UIStoryboard(name: NewsListStoryboardName, bundle: nil).instantiateViewController(withIdentifier: NewsListViewControllerStoryboardIdentifier) as! NewsListViewController
        
        let presenter = NewsListPresenter()
        
        let newsListService = NewsListServiceAssembly().buildNewsListService(delegate: presenter)
        
        // Inject properties
        viewController.output = presenter
        presenter.view = viewController
        presenter.router = viewController
        
        presenter.newsListService = newsListService
        
        completion(viewController, presenter)
        
    }
    
}
