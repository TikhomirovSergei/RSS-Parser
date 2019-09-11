//
//  FeedCell.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet var imageViewWrapper: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var contentViewWrapper: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
