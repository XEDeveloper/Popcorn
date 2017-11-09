//
//  SeasonTVCell.swift
//  Watcher
//
//  Created by Rj on 09/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class SeasonTVCell: UITableViewCell {

    @IBOutlet weak var photoImageview: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
