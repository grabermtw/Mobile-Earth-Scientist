//
//  WMSLayer.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/29/22.
//

import MapKit

class WMSLayer {
    let midCoordinate: CLLocationCoordinate2D
    let overlayBoundingMapRect: MKMapRect
    
    init(midCoordinate: CLLocationCoordinate2D, overlayBoundingMapRect: MKMapRect) {
        self.midCoordinate = midCoordinate
        self.overlayBoundingMapRect = overlayBoundingMapRect
    }
}
