//
//  AlertPresenter.swift
//  news-proj
//
//  Created by Евгений Иванов on 19.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

protocol ErrorAlertPresenter {
    func showAlert(errorMessage: String)
}

extension ErrorAlertPresenter where Self: UIViewController {
    
    func showAlert(errorMessage: String) {
       
        let alertController = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Ок", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
        
    }
    
}
