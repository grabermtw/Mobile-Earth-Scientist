//
//  ScienceShareTableViewCell.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/3/22.
//

import UIKit
import FirebaseDatabase

class ScienceShareTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameTextView: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var layerListTextView: UITextView!
    @IBOutlet weak var getTheseLayersButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var vc: ScienceShareViewController?
    
    var layerGroup: CustomLayerGroup? {
        didSet { // Populate the cell's UI fields
            if let layerGroup = layerGroup {
                self.groupNameTextView.text = layerGroup.groupName
                self.usernameLabel.text = "By \(layerGroup.username)"
                var layerList = ""
                for layerTitle in layerGroup.layerTitles {
                    layerList += "Layer: \(layerTitle)\n"
                }
                self.layerListTextView.text = layerList
                // The trash button is only available on layer groups that the current user created.
                if layerGroup.uid == UserInfo.uid {
                    deleteButton.isHidden = false
                } else {
                    deleteButton.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // When the user taps the button with the arrow pointing downward into the box, replace the layers in My Layers with these layers
    @IBAction func getTheseLayers(_ sender: Any) {
        if let layerGroup = layerGroup {
            GIBSData.myLayers.removeAll()
            for layerName in layerGroup.layerNames {
                if let wmsLayer = GIBSData.capabilities?.capability.layerParent.layers.first(where: { $0.name == layerName
                }) {
                    GIBSData.myLayers.append(MESLayerInfo(wmsLayer: wmsLayer))
                }
            }
            vc!.present(Alerter.makeInfoAlert(title: "Now using \(layerGroup.groupName)!", message: "If you go back to \"My Layers,\" you will find the layers from this layer group."), animated: true, completion: nil)
        }
    }
    
    // Called when the trash button is pressed.
    @IBAction func deleteLayerGroup(_ sender: Any) {
        if let id = layerGroup?.groupId {
            Database.database().reference().child("customLayerGroups").child(id).removeValue()
            vc?.layerGroups.removeAll(where: {
                (lg) in
                lg.groupId == id
            })
            vc?.tableView.reloadData()
        }
    }
}
