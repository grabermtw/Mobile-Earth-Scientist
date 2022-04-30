//
//  MapViewController.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit
import XMLCoder
import MapKit

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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var image: UIImage?
    var capabilities: WMS_Capabilities?
    let testLayer: String = "https://gibs.earthdata.nasa.gov/wms/epsg4326/best/wms.cgi?version=1.3.0&service=WMS&request=GetMap&format=image/jpeg&STYLE=default&bbox=-90,-180,90,180&CRS=EPSG:4326&HEIGHT=512&WIDTH=512&TIME=2021-11-25&layers=MODIS_Terra_SurfaceReflectance_Bands143"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        downloadXML {
            print("XML download successful!")
            print(self.capabilities?.capability.layerParent.layers[0].layers[0].style?.legendURL.onlineResource.url)
        }
        
        let location = CLLocationCoordinate2DMake(40.73085, -73.99750)
        let regionRadius: CLLocationDistance = 5500
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let size = MKMapSize(width: 1000, height: 1000)
        let wmsLayer = WMSLayer(midCoordinate: location, overlayBoundingMapRect: MKMapRect(origin: MKMapPoint(location), size: size))
        let overlay = WMSLayerOverlay(wmsLayer: wmsLayer)
        self.mapView.addOverlay(overlay)
        //let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 5000)
        //mapView.addOverlay(diskOverlay)
    }
    
    // rendererFor causes "invalid library file": https://stackoverflow.com/a/72047451
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("YIGGITY")
        if overlay is WMSLayerOverlay {
            let img = UIImage(named: "wms")
            return WMSLayerMapOverlayView(
                overlay: overlay,
                overlayImage: img!
                )
        }
        return MKOverlayRenderer()
    }
    /*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.blue
            return circleRenderer
        }
        else {
           return MKOverlayRenderer(overlay: overlay)
        }
    }*/
}

