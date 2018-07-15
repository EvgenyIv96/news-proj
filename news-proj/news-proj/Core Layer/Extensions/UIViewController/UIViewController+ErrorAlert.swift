//
//  UIViewController+ErrorAlert.swift
//  news-proj
//
//  Created by Евгений Иванов on 16.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(errorMessage: String) {
        
        let alertController = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)

        let closeAction = UIAlertAction(title: "Ок", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
}
