//
//  UserInfo.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import FirebaseAuth
import FirebaseDatabase

// Used for keeping track of a logged-in user's Firebase data
struct UserInfo {
    
    static var username: String?
    
    // Call this to populate the user fields after signing in
    static func getUserInfo(success:@escaping () -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("usersInfo").child(uid).observeSingleEvent(of: .value) {
                (user) in
                if let dict = user.value as? [String: String] {
                    print("dict contents: \(dict)")
                    username = dict["displayName"]
                }
                print("Logged in!")
                success()
            }
        } else {
            print("Not logged in")
        }
    }
    
    // call this to sign out
    static func signOutFirebase() {
        do {
            try Auth.auth().signOut()
            username = nil
        } catch let signOutError as NSError {
            print("Firebase sign-out error: \(signOutError)")
        }
    }
}
