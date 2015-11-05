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
    var friendList: [PFUser] = [PFUser](),
        userSearchResults: [PFUser]!,
        selectedFriends:[PFUser] = [PFUser]()
    let userQuery = PFUser.query()
    
    let FIND_FRIENDS_SEARCHBAR_PLACEHOLDER = "Find your friends"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.delegate = self
        userTable.dataSource = self
        currentUser = PFUser.currentUser()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        configureSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        findFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        if( selectedFriends.count > 0 ){
            ShareData.sharedInstance.invitedUsers = self.selectedFriends
        }
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let friend = friendList[indexPath.row]
        cell.textLabel!.text = friend.username!
        
        if cell.selected{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected == true{
            if( cell!.accessoryType == UITableViewCellAccessoryType.Checkmark ){
                cell!.accessoryType = UITableViewCellAccessoryType.None
                self.selectedFriends.removeAtIndex(indexPath.row)
            }else{
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.selectedFriends.append(friendList[indexPath.row])
            }
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.userQuery?.cancel()
    }
    func searchUsers(searchedUser:String){
        print("searchUsers executing. searchedUser [\(searchedUser)]")
        if( searchedUser.isEmpty ){
            return
        }
        
        userQuery?.limit = 200
        userQuery!.whereKey("username",  containsString: searchedUser.lowercaseString)
        findUsersByQuery(userQuery!,completion: { (results) -> Void in
            if var userResults = results as? [PFUser]{
                
                if( !userResults.isEmpty ){
                    if( userResults.contains(self.currentUser) ){
                        userResults.removeAtIndex(userResults.indexOf(self.currentUser)!)
                    }
                    
                    self.userSearchResults = userResults
                    self.searchController.active = false
                    self.performSegueWithIdentifier(Constants.SEGUE_FIND_FRIENDS, sender: self)
                    
                    /****
                     
                     REMOVE THIS LINE
                     
                    
                    
                    let selectedFriend:PFUser = userResults[0]
                     
                     

                    
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
                    ****/
                    
                }
                //self.userTable.reloadData()
            }
            
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == FIND_FRIENDS_SEGUE ){
            let vc = segue.destinationViewController as! FindFriendsTableViewController
            vc.userSearchResults = self.userSearchResults
        }
    }
    
    func findFriends(){
        self.friendList = []
        let query = PFQuery(className: BrewviteFriend.parseClassName())
        query.whereKey("user", equalTo: currentUser)
        query.includeKey("friend")
        Utils.findUsersByQuery(query,completion: { (results) -> Void in
            if let friendResults = results as? [BrewviteFriend] {
                for brewFriend in friendResults{
                    self.friendList.append(brewFriend.friend)
                }
            }
            self.userTable.reloadData()
            
        })
    }

    
    func configureSearchController(){
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = self.FIND_FRIENDS_SEARCHBAR_PLACEHOLDER
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
