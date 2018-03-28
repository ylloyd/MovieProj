//
//  CustomSearchTableViewCell.swift
//  MovieProj
//
//  Created by Yvan Elessa on 21/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

class CustomSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
