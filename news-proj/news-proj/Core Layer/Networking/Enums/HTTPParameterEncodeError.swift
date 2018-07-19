//
//  HTTPParameterEncodeError.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

enum HTTPParameterEncodeError: String, Error {
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
