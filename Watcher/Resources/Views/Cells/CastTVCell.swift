//
//  CastTVCell.swift
//  Watcher
//
//  Created by Rj on 09/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class CastTVCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
