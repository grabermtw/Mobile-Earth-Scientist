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
    
    // These values come from https://nasa-gibs.github.io/gibs-api-docs/access-basics/#map-projections in the Web Mercator / "Google Projection" (EPSG:3857) section under "Native Coordinates"
    var northeastURL: String {
        makeLayerURL(bbox: "0,0,20037508.34278925,20037508.34278925")
    }
    var northwestURL: String {
        makeLayerURL(bbox: "-20037508.34278925,0,0,20037508.34278925")
    }
    var southeastURL: String {
        makeLayerURL(bbox: "0,-20037508.34278925,20037508.34278925,0")
    }
    var southwestURL: String {
        makeLayerURL(bbox: "-20037508.34278925,-20037508.34278925,0,0")
    }
    
    init(wmsLayer: WMS_Capabilities.Capability.LayerParent.LayerInfo) {
        self.wmsLayer = wmsLayer
    }
    
    // construct a URL for getting a layer image
    func makeLayerURL(bbox: String) -> String {
        var timeSpec = ""
        if let layerTime = self.layerTime {
            timeSpec = "&TIME=\(layerTime)"
        }
        return "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi?version=1.3.0&service=WMS&request=GetMap&format=\(MESLayerInfo.wmsImgFormat)&STYLE=default&bbox=\(bbox)&CRS=EPSG:3857&HEIGHT=\(MESLayerInfo.imgSize)&WIDTH=\(MESLayerInfo.imgSize)\(timeSpec)&layers=\(wmsLayer.name)"
    }
    
    // When testing equality, all we care about is the WMS layer.
    // Other info is not important here
    static func == (lhs: MESLayerInfo, rhs: MESLayerInfo) -> Bool {
        return lhs.wmsLayer == rhs.wmsLayer
    }
}
