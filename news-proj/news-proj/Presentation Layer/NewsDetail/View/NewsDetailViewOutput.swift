//
//  NewsDetailViewOutput.swift
//  news-proj
//
//  Created by Евгений Иванов on 15.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

protocol NewsDetailViewOutput: AnyObject {
    
    /// Method is used to tell presenter that view ready for work.
    func didTriggerViewReadyEvent()
    
}
