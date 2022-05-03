//
//  LoginUserViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import UIKit
import Firebase

class LoginUserViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loggingInMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loggingInMessage.isHidden = true
        self.handleLoggedIn()
    }
    
    // Attempt to perform the login
    func login(success:@escaping (Bool, Error?) -> Void) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            success(false, "We're missing some fields here!" as? Error)
            return
        }
        print("User email: \(email)")
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Incorrect Credentials!", message: "Wrong username and/or password!", preferredStyle: .alert)
                let cancel = UIAlertAction(title:"OK", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
                success(false, error)
            }
            success(true, nil)
        }
    }
    
    // When the "Log in" button is pressed
    @IBAction func logInButtonPressed(_ sender: Any) {
        loggingInMessage.isHidden = false
        login(success: {(result,error) in
            if result {
                UserInfo.getUserInfo(success: {
                    // Switch to the "Log Out" view
                    self.handleLoggedIn()
                })
            } else {
                self.loggingInMessage.isHidden = true
                print(error!)
            }
        })
    }
    
    // When the log out button is pressed...
    @IBAction func logOutPressed(_ sender: Any) {
        // Perform logout
        UserInfo.signOutFirebase()
        // Switch to the "Log In" view
        self.handleLoggedIn()
    }
    
    // Used for updating the view based on whether the user is logged in or not
    private func handleLoggedIn() {
        // Do any additional setup after loading the view.
        if let username = UserInfo.username {
            // Show the the "Log Out" view
            self.loginView.isHidden = true
            self.logoutView.isHidden = false
            self.usernameLabel.text = username
        } else {
            // Show the "Log In" view
            self.logoutView.isHidden = true
            self.loginView.isHidden = false
            loggingInMessage.isHidden = true
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    
    
    // MARK: - Navigation
    
    // This is just to allow the "Register User!" button on the register user page to also bring the user back to this view
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {

    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
