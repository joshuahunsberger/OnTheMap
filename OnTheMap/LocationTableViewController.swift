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
    
}
