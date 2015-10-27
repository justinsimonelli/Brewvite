//
//  CreateInviteViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/20/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import Firebase

class CreateInviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userTable: UITableView!

    let userArray:[String] = ["justinsims", "skvak", "216aj", "betsdudes", "haliesimo", "eionsimo", "abbeysimo", "tarski", "mjt", "mark", "will", "jon", "scott"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.delegate = self
        userTable.dataSource = self
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = userArray[indexPath.row]
        
        if cell.selected
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected == true
        {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userArray.count
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
