//
//  RegisterUserViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordReenterTextField: UITextField!
    @IBOutlet weak var registeringMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registeringMessage.isHidden = true
    }
    
    // Registers user similar to Assignment 4
    func registerUser(success:@escaping (Bool, Error?) -> Void) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let rePassword = passwordReenterTextField.text, let displayName = displayNameTextField.text else {
            success(false, "We're missing some fields here!" as? Error)
            return
        }
        // We've got two password fields, so they better match!
        if password != rePassword {
            self.present(Alerter.makeInfoAlert(title: "Registration error", message: "Both password fields must match!"), animated: true, completion: nil)
            success(false, "Both password fields must match!" as? Error)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if let newError = error {
                self.present(Alerter.makeInfoAlert(title: "Registration Error", message: newError.localizedDescription), animated: true, completion: nil)
                success(false, error)
                return
            }
            let ref = Database.database().reference(fromURL: "https://mobile-earth-scientist-default-rtdb.firebaseio.com/")
            let userRef = ref.child("usersInfo").child((user?.user.uid)!)
            let val = ["email":email, "displayName":displayName]
            userRef.updateChildValues(val, withCompletionBlock: { (error, ref) in
                if error != nil {
                    success(false,error)
                    return
                }
                else {
                    success(true,nil)
                }
            })
        }
    }

    // when the "Register User!" button is pressed
    @IBAction func registerUserButton(_ sender: Any) {
        self.registeringMessage.isHidden = false
        registerUser(success: { (result, error) in
            if result {
                print("User registered!")
                UserInfo.getUserInfo(success: {
                    // segue back one screen
                    self.performSegue(withIdentifier: "backToLogin", sender: self)
                })
            } else {
                self.registeringMessage.isHidden = true
                if let regError = error {
                    print("Error registering user: \(regError)")
                }
            }
        })
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
