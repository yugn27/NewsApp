//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Yash Nayak on 14/02/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    // MARK: - Instance Vars
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Setting corner radius of imageview
        imgView.layer.cornerRadius = 8
        imgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
