//
//  MyLayersViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import UIKit

class MyLayersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        createDatePicker()
    }
    
    // This function determines the earliest and the latest dates of all the dates to create the date picker.
    func createDatePicker() {
        // Get the date structs for the dates associated with each layer
        var earliestDate: Date?
        var latestDate: Date?
        var defaultDates: [Date] = []
        for layerInfo in GIBSData.myLayers {
            // get the earliest date
            if let currentEarliestDate = earliestDate {
                if let earliestLayerDate = layerInfo.dateRange?.0 {
                    if earliestLayerDate < currentEarliestDate {
                        earliestDate = earliestLayerDate
                    }
                }
            } else {
                earliestDate = layerInfo.dateRange?.0
            }
            // get the latest date
            if let currentLatestDate = latestDate {
                if let latestLayerDate = layerInfo.dateRange?.1 {
                    if latestLayerDate > currentLatestDate {
                        latestDate = latestLayerDate
                    }
                }
            } else {
                latestDate = layerInfo.dateRange?.1
            }
            if let layerDefaultDate = layerInfo.defaultDate {
                defaultDates.append(layerDefaultDate)
            }
        }
        // Reveal the date picker if we have layers with dates
        if earliestDate != nil && latestDate != nil {
            datePicker.isHidden = false
            datePicker.minimumDate = earliestDate
            datePicker.maximumDate = latestDate
        } else {
            datePicker.isHidden = true
            GIBSData.date = nil
        }
    }
    
    @IBAction func dateChosen(_ sender: Any) {
        GIBSData.date = datePicker.date
    }
    
    // MARK: - Table functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GIBSData.myLayers.count
    }
    
    // Populate the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLayersCell")! as! MyLayersTableViewCell
        cell.titleLabel?.text = GIBSData.myLayers[indexPath.row].wmsLayer.title
        cell.layerToggleSwitch.isOn = GIBSData.myLayers[indexPath.row].enabled
        cell.wmsLayer = GIBSData.myLayers[indexPath.row]
        cell.setLayerFavoritedToggle(GIBSData.myFavorites.contains(where: {
            $0.wmsLayer == GIBSData.myLayers[indexPath.row].wmsLayer
        }))
        return cell
    }
    
    // Handle entering/exiting edit mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Toggle the Edit button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
    }
    
    // Enable editing the table view!.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            GIBSData.myLayers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            createDatePicker()
        }
    }
    
    // Enable rearranging the layers!
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movingRow = GIBSData.myLayers.remove(at: fromIndexPath.row)
        GIBSData.myLayers.insert(movingRow, at: to.row)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
