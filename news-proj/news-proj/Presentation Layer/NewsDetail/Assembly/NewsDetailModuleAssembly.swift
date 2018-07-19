//
//  NewsDetailAssembly.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class NewsDetailModuleAssembly {
    
    func buildNewsDetailModule(_ completion: (UIViewController, NewsDetailModuleInput) -> Void) {
        
        // Creating module components
        let viewController = UIStoryboard(name: NewsDetailStoryboardName, bundle: nil).instantiateViewController(withIdentifier: NewsDetailViewControllerStoryboardIdentifier) as! NewsDetailViewController
        
        let presenter = NewsDetailPresenter()
        
        let newsDetailService = NewsDetailServiceAssembly().buildNewsDetailService(delegate: presenter)
        
        // Inject properties
        viewController.output = presenter
        presenter.view = viewController
        presenter.router = viewController
        presenter.newsDetailService = newsDetailService
        
        completion(viewController, presenter)
        
    }
    
}
