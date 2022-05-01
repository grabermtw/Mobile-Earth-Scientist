//
//  SearchTableViewCell.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addLayerButton: UIButton!
    var wmsLayer: WMS_Capabilities.Capability.LayerParent.LayerInfo?
    var layerAdded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // When the add layer button is pressed...
    @IBAction func toggleLayerPressed(_ sender: Any) {
        if let wmsLayer = wmsLayer {
            if layerAdded {
                GIBSData.myLayers.removeAll(where: {
                    $0.wmsLayer == wmsLayer
                })
                setLayerAddedToggle(false)
            }
            else {
                GIBSData.myLayers.append(MESLayerInfo(wmsLayer: wmsLayer))
                setLayerAddedToggle(true)
            }
        }
    }
    
    // Used for informing the button of whether its layer is in GIBSData.myLayers
    func setLayerAddedToggle(_ added: Bool) {
        if added {
            layerAdded = true
            addLayerButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            layerAdded = false
            addLayerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
}
