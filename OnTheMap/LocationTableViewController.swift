//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/17/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class LocationTableViewController: StudentLocationViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: Table view functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = ParseClient.sharedInstance().studentLocations {
            return locations.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentLocationCell")! as UITableViewCell
        let location = ParseClient.sharedInstance().studentLocations![indexPath.row]
        
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel!.text = location.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        
        if let location = ParseClient.sharedInstance().studentLocations {
            let link = location[indexPath.row].mediaURL
            if let url = NSURL(string: link) {
                app.openURL(url)
            } else {
                let alert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                presentViewController(alert, animated: false, completion: nil)
            }
        }
    }
    
    //MARK: Refresh
    override func refresh() {
        getStudentLocations() { _ in
            self.tableView.reloadData()
        }
    }
}
