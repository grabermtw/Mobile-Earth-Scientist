//
//  Alerter.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/3/22.
//

import UIKit

struct Alerter {
    // Giving this a static function to simplify code in the Science Share and login/register sections
    static func makeInfoAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title:"OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        return alertController
    }
}
