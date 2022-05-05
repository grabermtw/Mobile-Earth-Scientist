//
//  MESLayerInfo.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/1/22.
//

// Holds information about how a layer is being used in Mobile Earth Scientist
struct MESLayerInfo: Equatable {

    static let wmsImgFormat = "image/png"
    static let imgSize = "1024"
    
    let wmsLayer: WMS_Capabilities.Capability.LayerParent.LayerInfo
    var enabled: Bool = true
    
    var layerTime: String? {
        wmsLayer.dimension?.timeDefault
    }
    
    // When testing equality, all we care about is the WMS layer.
    // Other info is not important here
    static func == (lhs: MESLayerInfo, rhs: MESLayerInfo) -> Bool {
        return lhs.wmsLayer == rhs.wmsLayer
    }
}
