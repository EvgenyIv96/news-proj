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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewsCountLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with cellModel: NewsListCellModel) {
        titleLabel.text = cellModel.title
        viewsCountLabel.text = cellModel.viewsCountString
    }
    
    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        viewsCountLabel.text = "0"
    }
}
