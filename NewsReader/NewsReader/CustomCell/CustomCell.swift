//
//  CustomCell.swift
//  NewsReader
//
//  Created by Andriy Tsymbalyuk on 4/16/19.
//  Copyright © 2019 Andriy Tsymbalyuk. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var urlToImage: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
