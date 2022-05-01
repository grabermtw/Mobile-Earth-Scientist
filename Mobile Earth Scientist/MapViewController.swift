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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        // demo layer, temporary
        addWMSLayerOverlay(northeast: UIImage(named:"wms_northeast")!, northwest: UIImage(named:"wms_northwest")!, southeast: UIImage(named:"wms_southeast")!, southwest: UIImage(named:"wms_southwest")!)
        
        GIBSData.downloadXML {
            print("XML download successful!")
            print(GIBSData.capabilities?.capability.layerParent.layers[0].style?.legendURL.onlineResource.url)
        }
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
       
        
        let centerCorner = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // NORTHEAST
        let northeastCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.maxLonWGS84)
        let northeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northeastCorner), icon: northeast)
        northeastOverlay.map = self.mapView
        
        // NORTHWEST
        let northwestCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.minLonWGS84)
        let northwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northwestCorner), icon: northwest)
        northwestOverlay.map = self.mapView
        
        // SOUTHEAST
        let southeastCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.maxLonWGS84)
        let southeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southeastCorner, coordinate: centerCorner), icon: southeast)
        southeastOverlay.map = self.mapView
        
        // SOUTHWEST
        let southwestCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.minLonWGS84)
        let southwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southwestCorner, coordinate: centerCorner), icon: southwest)
        southwestOverlay.map = self.mapView
    }
    
   
}

