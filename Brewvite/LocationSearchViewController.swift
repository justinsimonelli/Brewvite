//
//  LocationSearchViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/14/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchResults = [FoursquareSearchResult]()
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var dataArray = [String]()
    var filteredArray = [String]()
    let shareData = ShareData.sharedInstance
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var searchResultsTable: UITableView!

    @IBAction func closeAction(sender: UIButton) {
        searchController.view.removeFromSuperview()
        shareData.selectedTransition = shareData.TRANSITION_ACTIONS.venues
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        loadListOfCountries()
        configureSearchController()
        
        self.searchResultsTable.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("venueCell", forIndexPath: indexPath) 
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = searchResultsTable.indexPathForSelectedRow!
        let currentCell = searchResultsTable.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let selectedData = currentCell.textLabel!.text!
        
        print(selectedData)
        shareData.selectedVenue = selectedData
        shareData.selectedTransition = shareData.TRANSITION_ACTIONS.venues
        searchController.view.removeFromSuperview()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = NSBundle.mainBundle().pathForResource("countries", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            do {
                let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                dataArray = content.componentsSeparatedByString("\n")
            } catch _ as NSError {
                
            }
            // Reload the tableview.
            self.searchResultsTable.reloadData()
        }
    }
    
    func configureSearchController(){
        self.searchResultsTable.delegate = self
        self.searchResultsTable.dataSource = self
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Find a spot..."
        self.searchController.searchBar.sizeToFit()
        self.searchResultsTable.tableHeaderView = self.searchController.searchBar

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.searchResultsTable.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.searchResultsTable.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.searchResultsTable.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.searchResultsTable.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country
            
            return (countryText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        // Reload the tableview.
        self.searchResultsTable.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country
            
            return (countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        self.searchResultsTable.reloadData()
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
