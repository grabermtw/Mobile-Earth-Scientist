//
//  WelcomeViewController.swift
//  Mobile Earth Scientist
//
//  Created by mgraber on 5/2/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var createdByLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make text invisible to prep for animation
        welcomeLabel.alpha = 0
        titleLabel.alpha = 0
        createdByLabel.alpha = 0
        textView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Animate a staggered fade-in of the text
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, animations: {
            self.welcomeLabel.alpha = 1.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 1, animations: { self.titleLabel.alpha = 1.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 2, animations: { self.textView.alpha = 1.0
            self.createdByLabel.alpha = 1.0
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
