//
//  ScienceShareViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import UIKit
import FirebaseDatabase

class ScienceShareViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var layerGroups: [CustomLayerGroup] = []
    var maxGroupId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchLayerGroups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Change the "log in" button to be the person's username if they're already logged in
        if let username = UserInfo.username {
            loginButton.title = username
        } else {
            loginButton.title = "Log In"
        }
        tableView.reloadData()
    }
    
    // MARK: - Firebase functions
    
    // Fetch all the custom layer groups from Firebase
    func fetchLayerGroups() {
        self.layerGroups.removeAll()
        Database.database().reference().child("customLayerGroups").observe(.childAdded, with: {
            (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let fetchedGroup = CustomLayerGroup(username: dict["username"] as! String, uid: dict["uid"] as! String, groupName: dict["groupName"] as! String, layerNames: dict["layerNames"] as! [String], layerTitles: dict["layerTitles"] as! [String], groupId: snapshot.key)
                if let id = Int(snapshot.key) {
                    if id > self.maxGroupId {
                        self.maxGroupId = id
                    }
                }
                self.layerGroups.append(fetchedGroup)
                self.tableView.reloadData()
            }
        })
    }
    
    // When the upload button (the one with the cloud and arrow) is pressed, attempt to upload the layers in "My Layers"
    @IBAction func uploadButton(_ sender: Any) {
        // first ensure that the user is logged in
        if let username = UserInfo.username {
            // next ensure that there are actually layers to upload
            if GIBSData.myLayers.count == 0 {
                self.present(Alerter.makeInfoAlert(title: "No layers to share!", message: "You need to add some layers to the \"My Layers\" list first!"), animated: true, completion: nil)
                return
            }
            let shareRef = Database.database().reference().child("customLayerGroups").child("\(self.maxGroupId + 1)")
            
            // Get the user's group name
            var groupName = ""
            let groupNameAlert = UIAlertController(title:"Input your group name!", message: "Your layer group will include whatever layers are currently in your \"My Layers\" list.", preferredStyle: .alert)
            groupNameAlert.addTextField { (groupNameTextField) in
                // default text
                groupNameTextField.text = "\(username)'s interesting layers"
            }
            let submit = UIAlertAction(title:"Submit", style: .default, handler: { [weak groupNameAlert] (_) in
                groupName = (groupNameAlert?.textFields![0].text)!
                // Get the layers in the user's "My Layers"
                var layerNames: [String] = []
                var layerTitles: [String] = []
                for layerInfo in GIBSData.myLayers {
                    layerNames.append(layerInfo.wmsLayer.name)
                    layerTitles.append(layerInfo.wmsLayer.title)
                }
                let newCustomLayerGroupInfo = ["username": username, "uid": UserInfo.uid!, "groupName": groupName, "layerNames": layerNames, "layerTitles": layerTitles] as [String : Any]
                shareRef.updateChildValues(newCustomLayerGroupInfo as [AnyHashable : Any], withCompletionBlock: {
                    (error, ref) in
                    // Present an alert with an appropriate message after submitting
                    var title = "\(groupName) has been submitted!"
                    var message = "Good work!"
                    if let newError = error {
                        print(newError.localizedDescription)
                        title = "Error uploading custom layers"
                        message = newError.localizedDescription
                    }
                    self.present(Alerter.makeInfoAlert(title: title, message: message), animated: true, completion: nil)
                })
            })
            groupNameAlert.addAction(submit)
            self.present(groupNameAlert, animated: true, completion: nil)
            
        } else {
            self.present(Alerter.makeInfoAlert(title: "Log in to share your layers", message: "After logging in, you'll be able to upload the layers in the \"My Layers\" section!"), animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Table functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layerGroups.count
    }
    
    // Populate the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerGroupCell")! as! ScienceShareTableViewCell
        cell.layerGroup = layerGroups[indexPath.row]
        cell.vc = self
        return cell
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
