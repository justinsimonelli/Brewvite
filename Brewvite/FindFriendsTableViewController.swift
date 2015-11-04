//
//  FindFriendsTableViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 11/3/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import Parse

class FindFriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var friendTable: UITableView!
    
    var searchController: UISearchController!
    var currentUser:PFUser!
    var userSearchResults: [PFUser]!,
    selectedFriends:[PFUser] = [PFUser]()
    let userQuery = PFUser.query()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self
        friendTable.dataSource = self
        currentUser = PFUser.currentUser()
        //configureSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        
        // Configure the cell...
        let friend = userSearchResults[indexPath.row]
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
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.userInteractionEnabled = false
            addFriendToFriendsList(userSearchResults[indexPath.row])
            //self.selectedFriends.append(userSearchResults[indexPath.row])
        }
        
        print(self.selectedFriends)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userSearchResults.count
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
        
        
        self.userQuery?.limit = 200
        self.userQuery!.whereKey("username",  containsString: searchedUser.lowercaseString)
        /*
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
        self.friendTable.reloadData()
        }
        
        })
        */
    }
    
    func addFriendToFriendsList(selectedFriend:PFUser) -> Void{
        let friendObj = PFObject(className: BrewviteFriend.parseClassName())
        friendObj["user"] = self.currentUser
        friendObj["friend"] = selectedFriend
        
        friendObj.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if succeeded {
                print("Object Uploaded")
                //self.friendTable.reloadData()
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    func configureSearchController(){
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.returnKeyType = UIReturnKeyType.Search
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Find your friends"
        self.searchController.searchBar.sizeToFit()
        self.friendTable.tableHeaderView = self.searchController.searchBar
        self.friendTable.reloadData()
        
    }
}
