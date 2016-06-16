//
//  DeviceListController.swift
//
//  Created by Om on 5/3/16.
//  Copyright © 2016 Samsung. All rights reserved.
//

import UIKit
import SmartView
class DeviceListController: UITableViewController
{
    var didFindServiceObserver: AnyObject? = nil
    
    var didRemoveServiceObserver: AnyObject? = nil

   
    @IBOutlet var mtableview: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"DeviceNameCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        didFindServiceObserver =  HelloWorldController.sharedInstance.search.on(MSDidFindService) { [unowned self] notification in
            self.tableView.reloadData()
        }
        didRemoveServiceObserver = HelloWorldController.sharedInstance.search.on(MSDidRemoveService) {[unowned self] notification in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        HelloWorldController.sharedInstance.search.off(didFindServiceObserver!)
        HelloWorldController.sharedInstance.search.off(didRemoveServiceObserver!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if HelloWorldController.sharedInstance.search.isSearching {
            return HelloWorldController.sharedInstance.services.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceNameCell", forIndexPath: indexPath)
        cell.textLabel!.text = HelloWorldController.sharedInstance.services[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if HelloWorldController.sharedInstance.search.isSearching {
            let service = HelloWorldController.sharedInstance.services[indexPath.row] as Service
            HelloWorldController.sharedInstance.selectedService = service
            
            HelloWorldController.sharedInstance.connect(service)
        }
        dismissViewControllerAnimated(true) { }
    }
}
