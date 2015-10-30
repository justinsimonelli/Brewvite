//
//  CreateInviteViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/20/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import Parse

class CreateInviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
   
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userTable: UITableView!
    var searchController: UISearchController!
    var currentUser:PFUser!
    var friendList: [PFUser] = [PFUser]()
    var userSearchResults: [PFUser]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.delegate = self
        userTable.dataSource = self
        currentUser = PFUser.currentUser()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        configureSearchController()
        findFriends()
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
        let friend = friendList[indexPath.row]
        cell.textLabel!.text = friend.username!
        
        /*
        if cell.selected{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        */
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected == true{
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendList.count
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchUsers(searchBar.text!)
    }
    
    func searchUsers(searchedUser:String){
        print("searchUsers executing. searchedUser [\(searchedUser)]")
        if( searchedUser.isEmpty ){
            return
        }
        
        let userQuery = PFUser.query()
        userQuery?.limit = 200
        userQuery!.whereKey("username",  containsString: searchedUser.lowercaseString)
        
        findUsersByQuery(userQuery!,completion: { (results) -> Void in
            if var userResults = results as? [PFUser]{
                
                if( !userResults.isEmpty ){
                    if( userResults.contains(self.currentUser) ){
                        userResults.removeAtIndex(userResults.indexOf(self.currentUser)!)
                    }
                    
                    /****
                     
                     REMOVE THIS LINE
                     
                     ****/
                    
                    let selectedFriend:PFUser = userResults[0]
                    /****
                     
                     REMOVE THIS LINE
                     
                     ****/
                    
                    let friendObj = PFObject(className: BrewviteFriend.parseClassName())
                    friendObj["user"] = self.currentUser
                    friendObj["friend"] = selectedFriend
                    
                    friendObj.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                        if succeeded {
                            print("Object Uploaded")
                        } else {
                            print("Error: \(error) \(error!.userInfo)")
                        }
                    }
                    
                }
                self.userTable.reloadData()
            }
            
        })
    }
    
    func findFriends(){
        let query = PFQuery(className: BrewviteFriend.parseClassName())
        query.whereKey("user", equalTo: currentUser)
        query.includeKey("friend")
        findUsersByQuery(query,completion: { (results) -> Void in
            if let friendResults = results as? [BrewviteFriend] {
                for brewFriend in friendResults{
                    self.friendList.append(brewFriend.friend)
                }
            }
            self.userTable.reloadData()
            
        })
    }
    
    /**
     Return a list of PFUser objects given the provided query.
     **/
    func findUsersByQuery(query:PFQuery, completion: ((results: [PFObject]) -> Void)) {
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) friends.")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    completion(results: objects)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func configureSearchController(){
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Find your friends"
        self.searchController.searchBar.sizeToFit()
        self.userTable.tableHeaderView = self.searchController.searchBar
        self.userTable.reloadData()
        
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
