//
//  GoogleMapSuggestionTableViewCell.swift
//  LondonDreams
//
//  Created by Abhinay Varma on 10/18/17.
//  Copyright © 2017 Abhinay Varma. All rights reserved.
//

import UIKit

class GoogleMapSuggestionTableViewCell: UITableViewCell {
    @IBOutlet weak var imagetodisplay: UIImageView!
    @IBOutlet weak var titlePlace: UILabel!
    @IBOutlet weak var locationPlace: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
