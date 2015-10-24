//
//  LocationSearchViewController.swift
//  Brewvite
//
//  Created by Justin Simonelli on 10/14/15.
//  Copyright © 2015 Sims. All rights reserved.
//

import UIKit
import CoreLocation
import QuadratTouch
import MapKit

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    var session: Session!
    var currentTask: Task?
    var location: CLLocation!
    var venues: [JSONParameters]!
    let distanceFormatter = MKDistanceFormatter()
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBAction func closeAction(sender: UIButton) {
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        configureSearchController()
        session = Session.sharedSession()
        location = Utils.sharedInstance.attemptToRetrieveUserLocation()
        self.searchResultsTable.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if venues != nil {
            return venues!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let venue = venues[indexPath.row]
        if let venueLocation = venue["location"] as? JSONParameters {
            var detailText = ""
            if let distance = venueLocation["distance"] as? CLLocationDistance {
                detailText = distanceFormatter.stringFromDistance(distance)
            }
            if let address = venueLocation["address"] as? String {
                detailText = detailText +  " - " + address
            }
            cell.detailTextLabel?.text = detailText
        }
        cell.textLabel?.text = venue["name"] as? String
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchResultsTable.deselectRowAtIndexPath(indexPath, animated: true)
        let venue = self.venues[indexPath.row]
        ShareData.sharedInstance.selectedVenue = venue
        ShareData.sharedInstance.selectedTransition = ShareData.sharedInstance.TRANSITION_ACTIONS.venues
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.searchResultsTable.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.searchResultsTable.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
        self.searchResultsTable.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchResultsTable.reloadData()
        
        searchController.searchBar.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet(),
        strippedString = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSet);
        
        if( !strippedString.isEmpty && strippedString.characters.count > 1 )
        {
            if self.location == nil {
                return
            }
            
            currentTask?.cancel()
            var parameters = [Parameter.query:strippedString]
            parameters += self.location.parameters()
            currentTask = session.venues.search(parameters) {
                (result) -> Void in
                if let response = result.response {
                    self.venues = response["venues"] as? [JSONParameters]
                    self.searchResultsTable.reloadData()
                }
            }
            currentTask?.start()
        }
    }
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        
        // Reload the tableview.
        self.searchResultsTable.reloadData()
    }
    
}

extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}
