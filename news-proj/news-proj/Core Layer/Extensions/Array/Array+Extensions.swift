//
//  Array+Extensions.swift
//  news-proj
//
//  Created by Евгений Иванов on 13.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import Foundation

extension Array {
    
    /// Method is used to modify value type element at given index.
    ///
    /// - Parameters:
    ///   - index: Index of element which should be modified
    ///   - modifyElement: Element modification code
    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
    
}
