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
    @IBOutlet weak var layerFavoritedButton: UIButton!
    
    var wmsLayer: MESLayerInfo?
    var favorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // When the switch is switched to enable/disable the layer...
    @IBAction func switchToggled(_ sender: Any) {
        if let layerInfo = wmsLayer {
            if let idx = GIBSData.myLayers.firstIndex(where: {
                $0 == layerInfo
            }){
                GIBSData.myLayers[idx].enabled = !layerInfo.enabled
                self.wmsLayer = GIBSData.myLayers[idx]
            }
        }
    }
    
    // When the add favorite heart button is pressed...
    @IBAction func toggleLayerFavorited(_ sender: Any) {
        if let wmsLayer = wmsLayer {
            if favorite {
                GIBSData.myFavorites.removeAll(where: {
                    $0.wmsLayer == wmsLayer.wmsLayer
                })
                setLayerFavoritedToggle(false)
            }
            else {
                GIBSData.myFavorites.append(wmsLayer)
                setLayerFavoritedToggle(true)
            }
        }
    }
    
    // Used for informing the button of whether its layer is in GIBSData.myFavorites
    func setLayerFavoritedToggle(_ added: Bool) {
        if added {
            favorite = true
            layerFavoritedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            layerFavoritedButton.tintColor = .red
        } else {
            favorite = false
            layerFavoritedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            layerFavoritedButton.tintColor = .systemBlue
        }
    }

}
