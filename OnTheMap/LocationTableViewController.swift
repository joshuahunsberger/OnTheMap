//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/17/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Table view functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = ParseClient.sharedInstance().studentLocations {
            return locations.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentLocationCell")! as UITableViewCell
        let location = ParseClient.sharedInstance().studentLocations![indexPath.row]
        
        cell.textLabel!.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel!.text = location.mediaURL
        
        return cell
    }
    
}
