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
struct MapLayer {
    var imgs: [String: UIImage] = [:]
}

class MapViewController: UIViewController, UITableViewDataSource {
    
    let layerImgCache = NSCache<NSString, AnyObject>()
    var currentMapLayers: [MapLayer] = []
    
    @IBOutlet weak var legendsTableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    var image: UIImage?
    var capabilities: WMS_Capabilities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
        
        performSegue(withIdentifier: "WelcomeSegue", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.clear()
        currentMapLayers = []
        
        for layerInfo in GIBSData.myLayers.reversed() where layerInfo.enabled {
            currentMapLayers.append(MapLayer())
        }
        addWMSLayerOverlay()
        legendsTableView.reloadData()
    }
    
    // MARK: - Map Functions
    
    // From the slides
    // Used for downloading the layer quadrant images
    func downloadImageUsingCacheWithLink(urlLink: String, layerIndex: Int, imagePurpose: String, completion: @escaping () -> Void) {
        
        if urlLink.isEmpty {
            print("Link is empty")
            return
        }

        // check cache first
        if let cachedImage = self.layerImgCache.object(forKey: urlLink as NSString) as? UIImage {
            self.currentMapLayers[layerIndex].imgs[imagePurpose] = cachedImage
            completion()
            return
        }
        // otherwise, download
        let url = URL(string: urlLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            DispatchQueue.main.async {
                if let newImage = UIImage(data: data!) {
                    self.layerImgCache.setObject(newImage, forKey: urlLink as NSString)
                    self.currentMapLayers[layerIndex].imgs[imagePurpose] = newImage
                }
                completion()
            }
        }).resume()
    }
    
    // Add the four images representing the four quadrants of a layer to the map.
    // Google Maps crashes if an overlay image's bounding box goes too wide,
    // so for this project we use Northeast, Northwest, Southeast, Southwest quadrants to
    // make up a full layer
    func addWMSLayerOverlay() {
        // Add a new entry in the currentMapLayers list that will contain the new images
        let layerIndex = currentMapLayers.count
        currentMapLayers.append(MapLayer())
        
        let centerCorner = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        // NORTHEAST
        // download quadrant image
        downloadImageUsingCacheWithLink(urlLink: GIBSData.northeastURL, layerIndex: layerIndex, imagePurpose: "northeast", completion: { () -> Void in
            let northeastCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.maxLonWGS84)
            let northeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northeastCorner), icon: self.currentMapLayers[layerIndex].imgs["northeast"])
            northeastOverlay.map = self.mapView
        })
        
        // NORTHWEST
        downloadImageUsingCacheWithLink(urlLink: GIBSData.northwestURL, layerIndex: layerIndex, imagePurpose: "northwest", completion: { () -> Void in
            let northwestCorner = CLLocationCoordinate2D(latitude: GIBSData.maxLatWGS84, longitude: GIBSData.minLonWGS84)
            let northwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: centerCorner, coordinate: northwestCorner), icon: self.currentMapLayers[layerIndex].imgs["northwest"])
            northwestOverlay.map = self.mapView
        })
        
        // SOUTHEAST
        downloadImageUsingCacheWithLink(urlLink: GIBSData.southeastURL, layerIndex: layerIndex, imagePurpose: "southeast", completion: { () -> Void in
            let southeastCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.maxLonWGS84)
            let southeastOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southeastCorner, coordinate: centerCorner), icon: self.currentMapLayers[layerIndex].imgs["southeast"])
            southeastOverlay.map = self.mapView
        })
        
        // SOUTHWEST
        downloadImageUsingCacheWithLink(urlLink: GIBSData.southwestURL, layerIndex: layerIndex, imagePurpose: "southwest", completion: { () -> Void in
            let southwestCorner = CLLocationCoordinate2D(latitude: GIBSData.minLatWGS84, longitude: GIBSData.minLonWGS84)
            let southwestOverlay = GMSGroundOverlay(bounds:GMSCoordinateBounds(coordinate: southwestCorner, coordinate: centerCorner), icon: self.currentMapLayers[layerIndex].imgs["southwest"])
            southwestOverlay.map = self.mapView
        })
    }
    
    // MARK: - Legends Table functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let layersWithLegends = GIBSData.myLayers.filter({
            if $0.enabled {
                if let _ = $0.wmsLayer.style?.legendURL.onlineResource.url {
                    return true
                }
            }
            return false
        })
        
        // Adjust table behavior depending on how many legends are used
        switch(layersWithLegends.count) {
        // hide the table if there are no legends to show
        case 0:
            tableView.isHidden = true
        // disable scrolling if there is only 1 legend
        case 1:
            tableView.isScrollEnabled = false
            tableView.isHidden = false
        // otherwise enable scrolling to see all the legends
        default:
            tableView.isScrollEnabled = true
            tableView.isHidden = false
        }
        return layersWithLegends.count
    }
    
    // Download and display the legends for the layers that have them
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LegendCell")! as! LegendTableViewCell
        if let legendURL = GIBSData.myLayers.filter({ $0.enabled })[indexPath.row].wmsLayer.style?.legendURL.onlineResource.url {
            downloadImageUsingCacheWithLink(urlLink: legendURL, layerIndex: indexPath.row, imagePurpose: "legend", completion: { () -> Void in
                cell.legendImageView.image = self.currentMapLayers[indexPath.row].imgs["legend"]
            })
        }
        return cell
    }
    
    
    // MARK: - Navigation
    
    // This is just to allow the "Begin!" button on the welcome page to also bring the user back to this view
    @IBAction func unwindToMapView(segue: UIStoryboardSegue) {

    }
}

