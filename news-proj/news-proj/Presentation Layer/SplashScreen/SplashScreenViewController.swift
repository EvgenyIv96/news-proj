//
//  SplashScreenViewController.swift
//  news-proj
//
//  Created by Евгений Иванов on 16.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    // MARK: - Class constructor
    static func splashScreenViewController() -> UIViewController {
        
        let viewController = UIStoryboard(name: SplashScreenStoryboardName, bundle: nil).instantiateViewController(withIdentifier: SplashScreenViewControllerStoryboardIdentifier)
        
        return viewController

    }
    
}
