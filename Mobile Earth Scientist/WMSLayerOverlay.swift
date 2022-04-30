//
//  WMSLayerOverlay.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/29/22.
//

import MapKit

class WMSLayerOverlay: NSObject, MKOverlay {
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect
    
    init (wmsLayer: WMSLayer) {
        coordinate = wmsLayer.midCoordinate
        boundingMapRect = wmsLayer.overlayBoundingMapRect
    }
}
