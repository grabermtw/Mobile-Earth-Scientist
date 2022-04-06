//
//  MapViewController.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit
import XMLCoder

// Errors that might appear when downloading GetCapabilities XML
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class MapViewController: UIViewController {
    
    var capabilities: WMS_Capabilities?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadXML {
            print("XML download successful!")
            print(self.capabilities?.capability.layerParent.layers[0].layers[0].style?.legendURL.onlineResource.url)
        }
    }


}

