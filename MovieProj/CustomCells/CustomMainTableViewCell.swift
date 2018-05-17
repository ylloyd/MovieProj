//
//  CustomMainTableViewCell.swift
//  MovieProj
//
//  Created by Yvan Elessa on 16/05/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class CustomMainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var movieDateViewed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
