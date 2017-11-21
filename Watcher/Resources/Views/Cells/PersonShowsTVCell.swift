//
//  PersonShowsTVCell.swift
//  Watcher
//
//  Created by Rj on 21/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class PersonShowsTVCell: UITableViewCell {

    @IBOutlet weak var profileIImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
