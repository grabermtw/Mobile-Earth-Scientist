//
//  MapViewController.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit

// Errors that might appear when downloading GetCapabilities JSON
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct GetCapabilities: Decodable {
    
}


class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

