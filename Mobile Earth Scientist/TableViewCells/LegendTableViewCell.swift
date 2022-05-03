//
//  LegendTableViewCell.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/1/22.
//

import UIKit

class LegendTableViewCell: UITableViewCell {

    @IBOutlet weak var legendImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
