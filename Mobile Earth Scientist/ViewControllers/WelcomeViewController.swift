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
    @IBOutlet weak var beginButton: UIButton!
    
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
        beginButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Animate a staggered fade-in of the text
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, animations: {
            self.welcomeLabel.alpha = 1.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 1, animations: { self.titleLabel.alpha = 1.0
        })
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 2, animations: {
            self.textView.alpha = 1.0
            self.createdByLabel.alpha = 1.0
            self.beginButton.alpha = 1.0
        })
    }
    
    
    // I don't have time, energy, or willpower to get the UI on this screen to rescale and reposition itself nicely in landscape orientation, so for my own mental health, we're just going to disable landscape orientation for this screen.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // restrict the view to only portrait mode
        return .portrait
    }
    override var shouldAutorotate: Bool {
        // no autorotation allowed in this view
        return false
    }
    
    
   
    // MARK: - Navigation
    
    // Return to the map screen when pressed
    @IBAction func exitWelcome(_ sender: Any) {
        // segue back one screen
        self.performSegue(withIdentifier: "backToMap", sender: self)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
