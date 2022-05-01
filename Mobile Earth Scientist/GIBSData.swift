//
//  GIBSData.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import GoogleMaps
import XMLCoder

// Everything in this struct is static
// GIBSData means "Global Imagery Browse Services Data"
struct GIBSData {
    // This URL points to the WMS GetCapabilities XML file for the EPSG:3857 projection that Google Maps uses
    static let wmsCapabilitiesURL = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0"
    
    // These values come from https://nasa-gibs.github.io/gibs-api-docs/access-basics/#map-projections in the Web Mercator / "Google Projection" (EPSG:3857) section under "WGS84 Coordinates"
    static let minLatWGS84: CLLocationDegrees = -85.051129
    static let maxLatWGS84: CLLocationDegrees = 85.051129
    static let minLonWGS84: CLLocationDegrees = -180
    static let maxLonWGS84: CLLocationDegrees = 180
    
    // This will hold all of the GetCapabilities data
    static var capabilities: WMS_Capabilities?
    
    static var myLayers: [WMS_Capabilities.Capability.LayerParent.LayerInfo] = []
    
    // download the XML info from the API, as done in the class slides with JSON
    static func downloadXML(completed: @escaping () -> ()) {
        let url = URL(string:wmsCapabilitiesURL)
        URLSession.shared.dataTask(with: url!){(data, response, err) in
            if err == nil {
                // check downloaded XML data
                guard let xmldata = data else { return }
                
                do {
                    print(xmldata)
                    self.capabilities = try XMLDecoder().decode(WMS_Capabilities.self, from: xmldata)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("XML downloading error!")
                    print(error)
                }
            }
        }.resume()
        return
    }
}
