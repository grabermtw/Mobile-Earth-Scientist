//
//  AppDelegate.swift
//  Mobile Earth Scientist
//
//  Created by Matthew William Graber on 4/4/22.
//

import UIKit
import GoogleMaps
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Set up CoreData container
    // from the CoreData documentation: https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MobileEarthScientistModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        // prevent duplicates from being saved
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Load Google Maps API key
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        else {
            print("Missing keys.plist, where the Google Maps API key should be found! You need to create a \"keys.plist\" file and add a field called \"google_maps_api_key\" to it, with its value being the API key.")
        }
        if let keysdict = keys {
            GMSServices.provideAPIKey(keysdict["google_maps_api_key"] as! String)
        }
        else {
            print("Missing Google Maps API key! You need to put that in keys.plist, labeling it as \"google_maps_api_key\".")
        }
        
        // Assign CoreData container
        GIBSData.container = persistentContainer
        
        // Download the GetCapabilities XML
        GIBSData.downloadXML {
            print("XML download successful!")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

