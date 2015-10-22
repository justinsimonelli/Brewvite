//
//  SelectTimeViewController
//  Brewvite
//
//  Created by Justin Simonelli on 10/20/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit

class SelectTimeViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    var buttonCenter:CGPoint!;
    
    @IBOutlet weak var selectedDate: UIDatePicker!
    
    
    @IBAction func valueChangedAction(sender: AnyObject) {
        ShareData.sharedInstance.selectedDate = selectedDate.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        //buttonCenter = closeButton.center
        print("selectedDate=\(ShareData.sharedInstance.selectedDate)")
        ShareData.sharedInstance.selectedTransition =  ShareData.sharedInstance.TRANSITION_ACTIONS.date
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
