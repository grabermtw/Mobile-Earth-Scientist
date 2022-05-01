//
//  MapViewController.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit
import XMLCoder
import GoogleMaps

// Used for holding the four images associated with each layer
struct MapLayerQuadrants {
    var northeast: UIImage?
    var northwest: UIImage?
    var southeast: UIImage?
    var southwest: UIImage?
}

class MapViewController: UIViewController {
    
    let layerImgCache = NSCache<NSString, AnyObject>()
    var currentMapLayers: [MapLayerQuadrants] = []
    
    @IBOutlet weak var mapView: GMSMapView!
    var image: UIImage?
    var capabilities: WMS_Capabilities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        // demo layer, temporary
        //addWMSLayerOverlay(northeast: UIImage(named:"wms_northeast")!, northwest: UIImage(named:"wms_northwest")!, southeast: UIImage(named:"wms_southeast")!, southwest: UIImage(named:"wms_southwest")!)
        
        GIBSData.downloadXML {
            print("XML download successful!")
            print(GIBSData.capabilities?.capability.layerParent.layers[0].style?.legendURL.onlineResource.url)
            print(GIBSData.capabilities?.capability.layerParent.layers[2].dimension?.timeDefault)
            print(GIBSData.capabilities?.capability.layerParent.layers[2].dimension?.timeRange)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.clear()
        for layerInfo in GIBSData.myLayers.reversed() where layerInfo.enabled {
            addWMSLayerOverlay(layerInfo: layerInfo)
        }
    }
    
    // MARK: - Map Functions
    
    // From the slides
    // Used for downloading the layer quadrant images
    func downloadQuadrantUsingCacheWithLink(urlLink: String, layerIndex: Int, quadrant: String, completion: @escaping () -> Void) {
        
        if urlLink.isEmpty {
            print("Link is empty")
            return
        }

        // check cache first
        if let cachedImage = self.layerImgCache.object(forKey: urlLink as NSString) as? UIImage {
            switch(quadrant) {
            case "northeast":
                self.currentMapLayers[layerIndex].northeast = cachedImage
            case "northwest":
                self.currentMapLayers[layerIndex].northwest = cachedImage
            case "southeast":
                self.currentMapLayers[layerIndex].southeast = cachedImage
            case "southwest":
                self.currentMapLayers[layerIndex].southwest = cachedImage
            default:
                print("Invalid quadrant: \(quadrant)")
            }
            completion()
            return
        }
        // otherwise, download
        let url = URL(string: urlLink)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            DispatchQueue.main.async {
                if let newImage = UIImage(data: data!) {
                    self.layerImgCache.setObject(newImage, forKey: urlLink as NSString)
                    switch(quadrant) {
                    case "northeast":
                        self.currentMapLayers[layerIndex].northeast = newImage
                    case "northwest":
                        self.currentMapLayers[layerIndex].northwest = newImage
                    case "southeast":
                        self.currentMapLayers[layerIndex].southeast = newImage
                    case "southwest":
                        self.currentMapLayers[layerIndex].southwest = newImage
                    default:
                        print("Invalid quadrant: \(quadrant)")
                    }
                    
                }
                completion()
            }
            
        }).resume()
    }
    
    // Add the four images representing the four quadrants of a layer to the map.
    // Google Maps crashes if an overlay image's bounding box goes too wide,
    // so for this project we use Northeast, Northwest, Southeast, Southwest quadrants to
    // make up a full layer
    func addWMSLayerOverlay(layerInfo: MESLayerInfo) {
       
        // Add a new entry in the currentMapLayers list that will contain the new images
        let layerIndex = currentMapLayers.count
        currentMapLayers.append(MapLayerQuadrants())
        
        let centerCorner = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // NORTHEAST
        // download quadrant image
        print(layerInfo.northeastURL)
        downloadQuadrantUsingCacheWithLink(urlLink: layerInfo.northeastURL, layerIndex: layerIndex, quadrant: "northeast", completion: { () -> Void in
            let northeastCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.maxLonWGS84)
            let northeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northeastCorner), icon: self.currentMapLayers[layerIndex].northeast)
            northeastOverlay.map = self.mapView
        })
        
        // NORTHWEST
        downloadQuadrantUsingCacheWithLink(urlLink: layerInfo.northwestURL, layerIndex: layerIndex, quadrant: "northwest", completion: { () -> Void in
            let northwestCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.minLonWGS84)
            let northwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northwestCorner), icon: self.currentMapLayers[layerIndex].northwest)
            northwestOverlay.map = self.mapView
        })
        
        // SOUTHEAST
        downloadQuadrantUsingCacheWithLink(urlLink: layerInfo.southeastURL, layerIndex: layerIndex, quadrant: "southeast", completion: { () -> Void in
            let southeastCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.maxLonWGS84)
            let southeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southeastCorner, coordinate: centerCorner), icon: self.currentMapLayers[layerIndex].southeast)
            southeastOverlay.map = self.mapView
        })
        
        // SOUTHWEST
        downloadQuadrantUsingCacheWithLink(urlLink: layerInfo.southwestURL, layerIndex: layerIndex, quadrant: "southwest", completion: { () -> Void in
            let southwestCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.minLonWGS84)
            let southwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southwestCorner, coordinate: centerCorner), icon: self.currentMapLayers[layerIndex].southwest)
            southwestOverlay.map = self.mapView
        })
    }
    
   
}

