//
//  AfterSplashViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/21/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import BAFluidView

class AfterSplashViewController: UIViewController {
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        Utils.sharedInstance.delay(1.0, closure: {})
        
        let _view:BAFluidView = BAFluidView(frame:self.view.frame)
        _view.fillColor = UIColor(red:0.99, green:0.56, blue:0.15, alpha:1.0)
        _view.fillAutoReverse = false
        _view.fillDuration = 3
        _view.fillRepeatCount = 1
        _view.alpha = 0.3
        
        let brewViewController = storyBoard.instantiateViewControllerWithIdentifier("brewViewController") as UIViewController
        
        UIView.animateWithDuration(2.6, animations: {
            _view.alpha = 1.0;
            }, completion: { (_) in
                Utils.sharedInstance.delay(1.0, closure: {
                    UIView.animateWithDuration(1, animations: {
                        self.view.insertSubview(brewViewController.view, belowSubview: _view)
                        _view.alpha = 0.0;
                        }, completion: { (_) in
                            _view.removeFromSuperview()
                    })
                    
                })
        })
        
        _view.fillTo(1.0)
        _view.startAnimation()
        
        self.view.insertSubview(_view, aboveSubview: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
