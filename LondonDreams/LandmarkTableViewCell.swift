//
//  LandmarkTableViewCell.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/13/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit

class LandmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var landmarkTitle: UILabel!
    @IBOutlet weak var landmarkImage: UIImageView!
    @IBOutlet weak var landmarkAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
