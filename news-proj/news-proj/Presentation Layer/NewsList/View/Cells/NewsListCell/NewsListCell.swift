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
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with cellModel: NewsListCellModel) {
        titleLabel.text = cellModel.title
        viewsCountLabel.text = cellModel.viewsCountString
    }
    
    // MARK: - Private
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        viewsCountLabel.text = "0"
    }
}
