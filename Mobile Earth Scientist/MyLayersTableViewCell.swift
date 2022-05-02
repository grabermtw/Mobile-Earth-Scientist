//
//  MyLayersTableViewCell.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import UIKit

class MyLayersTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var layerToggleSwitch: UISwitch!
    
    var layerInfo: MESLayerInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        if let layerInfo = layerInfo {
            if let idx = GIBSData.myLayers.firstIndex(where: {
                $0 == layerInfo
            }){
                GIBSData.myLayers[idx].enabled = !layerInfo.enabled
                self.layerInfo = GIBSData.myLayers[idx]
            }
        }
    }

}
