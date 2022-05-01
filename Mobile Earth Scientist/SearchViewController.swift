//
//  SearchViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var filteredData: [WMS_Capabilities.Capability.LayerParent.LayerInfo]?
    var searchController: UISearchController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        filteredData = GIBSData.capabilities?.capability.layerParent.layers

        // Set to nil to use current view controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        // don't obscure the "background" because that's where our table is!
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        /*// Uncomment this to put search bar in navigation bar, not sure if that's ideal...
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // MARK: - Table Management
    // Populate table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerSearchCell")! as! SearchTableViewCell
        cell.titleLabel?.text = filteredData![indexPath.row].title
        cell.wmsLayer = filteredData![indexPath.row]
        // Inform the cell of whether its layer was already added to GIBS.myLayers
        if GIBSData.myLayers.contains(where: {
            $0 == filteredData![indexPath.row]
        }) {
            cell.setLayerAddedToggle(true)
        } else {
            cell.setLayerAddedToggle(false)
        }
        return cell
    }
    
    // Number of cells in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        }
        else {
            return 0
        }
    }

    // Filter table via search
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? GIBSData.capabilities?.capability.layerParent.layers : GIBSData.capabilities?.capability.layerParent.layers.filter({
                (layer: WMS_Capabilities.Capability.LayerParent.LayerInfo) -> Bool in
                return layer.title.contains(searchText)
            })

            tableView.reloadData()
        }
    }
    
    /*
    // When a table cell is tapped... add its layer to our static list of layers
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        GIBSData.myLayers.append(filteredData![indexPath.row]) 
    }
     */
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

