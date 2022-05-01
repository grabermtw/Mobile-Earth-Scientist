//
//  MyLayersViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 4/30/22.
//

import UIKit

class MyLayersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(GIBSData.myLayers)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GIBSData.myLayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLayersCell")! as! MyLayersTableViewCell
        cell.titleLabel?.text = GIBSData.myLayers[indexPath.row].title
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
