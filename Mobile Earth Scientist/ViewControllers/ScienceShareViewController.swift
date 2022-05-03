//
//  ScienceShareViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import UIKit

class ScienceShareViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Change the "log in" button to be the person's username if they're already logged in
        if let username = UserInfo.username {
            loginButton.title = username
        } else {
            loginButton.title = "Log In"
        }
    }
    
    // MARK: - Table functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLayersCell")! as! MyLayersTableViewCell
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
