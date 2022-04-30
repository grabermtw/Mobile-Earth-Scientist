//
//  MapViewController.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit
import XMLCoder
import GoogleMaps

// Errors that might appear when downloading GetCapabilities XML
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

// direct from the slides: downloading an image from a URL
extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link)
        else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var image: UIImage?
    var capabilities: WMS_Capabilities?
    let testLayer: String = "https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi?version=1.3.0&service=WMS&request=GetMap&format=image/jpeg&STYLE=default&bbox=-90,-180,90,180&CRS=EPSG:4326&HEIGHT=512&WIDTH=512&TIME=2021-11-25&layers=MODIS_Terra_SurfaceReflectance_Bands143"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        addWMSLayerOverlay(northeast: UIImage(named:"wms_northeast")!, northwest: UIImage(named:"wms_northwest")!, southeast: UIImage(named:"wms_southeast")!, southwest: UIImage(named:"wms_southwest")!)
        
        downloadXML {
            print("XML download successful!")
            print(self.capabilities?.capability.layerParent.layers[0].layers[0].style?.legendURL.onlineResource.url)
        }
    }
    
    // download the XML info from the API, as done in the class slides with JSON
    func downloadXML(completed: @escaping () -> ()) {
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
    
    func downloadImage(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completed: @escaping () -> ()) {
        print("attempting download")
        guard let url = URL(string: link)
        else { return }
        print("ph boi")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else {
                print("ERRORRRRR: \(error?.localizedDescription)")
                return
            }
            print("we have image")
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
        return
    }
    
    // MARK: - Map Functions
    
    // Add the four images representing the four quadrants of a layer to the map.
    // Google Maps crashes if an overlay image's bounding box goes too wide,
    // so for this project we use Northeast, Northwest, Southeast, Southwest quadrants to
    // make up a full layer
    func addWMSLayerOverlay(northeast: UIImage, northwest: UIImage, southeast: UIImage, southwest: UIImage) {
        // These values come from https://nasa-gibs.github.io/gibs-api-docs/access-basics/#map-projections in the Web Mercator / "Google Projection" (EPSG:3857) section under "WGS84 Coordinates"
        let minLatWGS84: CLLocationDegrees = -85.051129
        let maxLatWGS84: CLLocationDegrees = 85.051129
        let minLonWGS84: CLLocationDegrees = -180
        let maxLonWGS84: CLLocationDegrees = 180
        
        let centerCorner = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // NORTHEAST
        let northeastCorner = CLLocationCoordinate2D(latitude: maxLatWGS84, longitude: maxLonWGS84)
        let northeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northeastCorner), icon: northeast)
        northeastOverlay.map = self.mapView
        
        // NORTHWEST
        let northwestCorner = CLLocationCoordinate2D(latitude: maxLatWGS84, longitude: minLonWGS84)
        let northwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northwestCorner), icon: northwest)
        northwestOverlay.map = self.mapView
        
        // SOUTHEAST
        let southeastCorner = CLLocationCoordinate2D(latitude: minLatWGS84, longitude: maxLonWGS84)
        let southeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southeastCorner, coordinate: centerCorner), icon: southeast)
        southeastOverlay.map = self.mapView
        
        // SOUTHWEST
        let southwestCorner = CLLocationCoordinate2D(latitude: minLatWGS84, longitude: minLonWGS84)
        let southwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southwestCorner, coordinate: centerCorner), icon: southwest)
        southwestOverlay.map = self.mapView
    }
    
   
}

