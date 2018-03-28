//
//  CustomSearchTableViewCell.swift
//  MovieProj
//
//  Created by Yvan Elessa on 21/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import UIKit

protocol CustomSearchTableViewCellDelegate {
    func callSegueFromCell(_ movie: MovieDB)
}

class CustomSearchTableViewCell: UITableViewCell {
    
    var delegate: CustomSearchTableViewCellDelegate!
    var movie: MovieDB?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var goToMovieSaveButton: UIButton!
    
    @IBAction func goToMovieSaveView(sender: AnyObject) {
        guard let movie = movie else {
            return
        }
        
        if(self.delegate != nil) {
            self.delegate.callSegueFromCell(movie)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
