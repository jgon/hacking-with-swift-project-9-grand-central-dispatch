//
//  MasterViewController.swift
//  Project9
//
//  Created by Jacques on 11/02/16.
//  Copyright © 2016 J4SOFT. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var petitions = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 1 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            [unowned self] in
                if let url = NSURL(string: urlString) {
                    if let data = try? NSData(contentsOfURL: url, options: []) {
                        let json = JSON(data: data)
                        
                        if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                            self.parseJSON(json)
                        } else {
                            self.showError()
                        }
                    } else {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
            }
    }
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let signatureCount = result["signatureCount"].stringValue
            let petition = ["title": title, "body": body, "signatureCount": signatureCount]
            petitions.append(petition)
        }
        dispatch_async(dispatch_get_main_queue()) {
            [unowned self] in
                self.tableView.reloadData()
            }
    }
    
    func showError() {
        dispatch_async(dispatch_get_main_queue()) {
            [unowned self] in
                let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = petitions[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let petition = petitions[indexPath.row]
        cell.textLabel!.text = petition["title"]
        cell.detailTextLabel!.text = petition["body"]
        return cell
    }
}

