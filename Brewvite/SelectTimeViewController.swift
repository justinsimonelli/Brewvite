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
    @IBOutlet weak var selectedDate: UIDatePicker!
    
    var date:NSDate?
    let TIME_INTERVAL = 5
    
    @IBAction func valueChangedAction(sender: AnyObject) {
        date = selectedDate.date
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        ShareData.sharedInstance.selectedTransition =  ShareData.sharedInstance.TRANSITION_ACTIONS.date
        if( date == nil){
            date = selectedDate.date
        }
        ShareData.sharedInstance.selectedDate = date
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        date = selectedDate.date
        let distance = calculateDistaceToNextTimeInterval(selectedDate.date)
        if( distance > 0){
            date = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Minute, value: distance, toDate: date!, options: [])
            selectedDate.setDate(date!, animated: true)
        }
        selectedDate.minimumDate = date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func calculateDistaceToNextTimeInterval(date: NSDate) -> Int{
        var TEN_MIN_INTERVAL = 10,
        INTERVAL = 5,
        distance = 0
        
        let comp = NSCalendar.currentCalendar().components((NSCalendarUnit.Minute), fromDate: date)
        if( comp.minute % TIME_INTERVAL != 0){
            
            let mod = (comp.minute % TEN_MIN_INTERVAL)
            if( mod > INTERVAL ){
                distance = (TEN_MIN_INTERVAL - mod)
            }else{
                distance = (INTERVAL - mod)
            }
        }
        return distance
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
