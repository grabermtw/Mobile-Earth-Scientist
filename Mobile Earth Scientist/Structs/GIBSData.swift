//
//  GIBSData.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import GoogleMaps
import XMLCoder
import CoreData

// Errors that might appear when downloading GetCapabilities XML
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

// Everything in this struct is static. This is to hold and help manage all the data that is shared between view controllers.
// GIBSData means "Global Imagery Browse Services Data"
struct GIBSData {
    // This URL points to the WMS GetCapabilities XML file for the EPSG:3857 projection that Google Maps uses
    static private let wmsCapabilitiesURL = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi?SERVICE=WMS&REQUEST=GetCapabilities&VERSION=1.3.0"
    
    // These values come from https://nasa-gibs.github.io/gibs-api-docs/access-basics/#map-projections in the Web Mercator / "Google Projection" (EPSG:3857) section under "WGS84 Coordinates"
    static let minLatWGS84: CLLocationDegrees = -85.051129
    static let maxLatWGS84: CLLocationDegrees = 85.051129
    static let minLonWGS84: CLLocationDegrees = -180
    static let maxLonWGS84: CLLocationDegrees = 180
    
    // CoreData container
    static var container: NSPersistentContainer! {
        didSet {
            backgroundContext = container.newBackgroundContext()
        }
    }
    static var backgroundContext: NSManagedObjectContext?
    
    static private var loadedFavorites: Bool = false
    
    // This will hold all of the GetCapabilities data
    static var capabilities: WMS_Capabilities? {
        didSet {
            // After the capabilities are downloaded, we can load the list of favorites out of persistent storage with CoreData
            if !loadedFavorites {
                loadFavorites()
            }
        }
    }
    
    // This will hold the layers that are present in the MyLayers table
    static var myLayers: [MESLayerInfo] = []
    // This will hold the layers that are present in the Favorites table
    static var myFavorites: [MESLayerInfo] = [] {
        // Use CoreData to persistently save the updated array each time it changes
        didSet {
            if loadedFavorites {
                Task {
                    await saveFavorites()
                }
            }
        }
    }
    
    // download the XML info from the GetCapabilities URL, as done in the class slides with JSON
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
    
    // MARK: - Core Data
    
    // Used for fetching the names of our favorite layers from CoreData storage and then making MESLayerInfo's from those names using the GetCapabilities info
    static private func loadFavorites() {
        do {
            let fetchReq: NSFetchRequest<FavoriteLayer> = FavoriteLayer.fetchRequest()
            let favorites = try container.viewContext.fetch(fetchReq)
            // Using the layer names, get the actual layers from the GetCapabilities XML as MESLayer's
            for favorite in favorites {
                if let wmsLayer = capabilities?.capability.layerParent.layers.first(where: {
                    favorite.layerName == $0.name
                }) {
                    myFavorites.append(MESLayerInfo(wmsLayer: wmsLayer))
                } else {
                    print("Warning: Favorite layer \(favorite.layerName!) was not found in GetCapabilities! This could be an error, or that layer may no longer be available from GIBS.")
                }
            }
        } catch {
            print("Error fetching favorites!")
        }
        loadedFavorites = true
    }
    
    // Save the list of favorites using CoreData
    static private func saveFavorites() async {
        if let context = self.backgroundContext {
            // First, delete all old favorites from CoreData
            let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteLayer")
            let deleteReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
            do {
                try container.viewContext.execute(deleteReq)
            } catch let error as NSError {
                print("Error deleting old favorites: \(error)")
            }
            
            // Then save the new favorites
            for favorite in myFavorites {
                await context.perform {
                    let faveLayer = FavoriteLayer(entity: FavoriteLayer.entity(), insertInto: context)
                    faveLayer.layerName = favorite.wmsLayer.name
                    do {
                        try context.save()
                    }
                    catch let error as NSError {
                        print("Error saving favorite layer \(favorite.wmsLayer.name): \(error)")
                    }
                }
            }
        }
    }
}
