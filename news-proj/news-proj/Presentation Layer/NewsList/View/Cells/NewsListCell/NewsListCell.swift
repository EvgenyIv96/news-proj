//
//  NewsListCell.swift
//  news-proj
//
//  Created by Евгений Иванов on 12.07.2018.
//  Copyright © 2018 Евгений Иванов. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {

    static let reuseIdentifier = "NewsListCellReuseIdentifier"
    static let height: CGFloat = 44.0

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Configuration
    
    // MARK: - Private
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
}
