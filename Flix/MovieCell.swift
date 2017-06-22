//
//  MovieCell.swift
//  Flix
//
//  Created by Mei-Ling Laures on 6/21/17.
//  Copyright © 2017 Mei-Ling Laures. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    // Outlets that are part of the cell of the table
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
