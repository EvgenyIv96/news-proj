//
//  ApplicationConstants.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

public enum ApplicationConstants {
    
    enum WebConstants {
        static let baseURLString = "https://cfg.tinkoff.ru/news/public/api/platform/v1/"
        static let timeoutInterval: TimeInterval = 5
        static let error = "Произошла ошибка"
        static let internetConnectionError = "Ошибка интернет-соединения"
    }
    
    enum CoreDataConstants {
        static let storeName = "Storage"
        static let modelName = "NewsProj"
    }
    
    enum Errors {
        static let domain = "ru.eivanov.news-proj.errors"
        struct codes {
            static let ContextHasNoChangesErrorCode = 567
        }
    }
    
}
