//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name(rawValue:"refresh"), object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentLocation.locations.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let currentStudent = StudentLocation.locations[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(currentStudent.firstName) \(currentStudent.lastName)"
        cell.detailTextLabel?.text = "\(currentStudent.mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = StudentLocation.locations[(indexPath as NSIndexPath).row]
        if let url = URL(string: currentStudent.mediaURL) {
            // check if your application can open the NSURL instance
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (successful) in
                })
            } else {
                showAlertwith(title: "URL invalid", message: "Check Url", vc: self)
            }
        }
        
    }
    
    func refreshView()
    {
        performOnMainthread {
            self.tableView.reloadData()
        }
    }

}
