//
//  WMSLayerMapOverlayView.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/29/22.
//

import MapKit

// https://www.raywenderlich.com/9956648-mapkit-tutorial-overlay-views
class WMSLayerMapOverlayView: MKOverlayRenderer {
    let overlayImage: UIImage
  
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
  
    override func draw(
        _ mapRect: MKMapRect,
        zoomScale: MKZoomScale,
        in context: CGContext
    ) {
        guard let imageReference = overlayImage.cgImage else { return }
        print("BOIS")
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}

