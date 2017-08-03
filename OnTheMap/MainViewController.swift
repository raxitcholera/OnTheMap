//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UITabBarController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "On the Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .reply, target: self, action: #selector(logoutClicked))
        let mapBarBtn = UIBarButtonItem.init(image: UIImage(named: "icon_pin"), style: .plain, target: self, action: #selector(mapBtnClicked))
        let refreshBarBtn = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBtnClicked))
        navigationItem.rightBarButtonItems = [mapBarBtn, refreshBarBtn]
        refreshData()
    }

    
    @objc private func logoutClicked()
    {
         ParseClient.sharedInstance().deleteSession { (responseData, error) in
            if(responseData != nil)
            {
                performOnMainthread {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            }
            else
            {
                showAlertwith(title: "Failed", message: "Unable to delete session", vc: self)
            }
        }
    }
    
    @objc private func mapBtnClicked()
    {
        let myLocation = StudentLocation.locations.filter({ ($0 as StudentLocation).uniqueKey == appDelegate.uniqueKey})
        
        if myLocation.count > 0 {
            
            showBooleanAlert(title: "", message: "You have already Posted a Student Location, would you like to OverWrite Your Current Location?", vc: self, completionHandler: { (choice) in
                if (choice){
                    let postVC  = self.storyboard?.instantiateViewController(withIdentifier: "locatorVC") as! AskLocationViewController
                    postVC.myLocation = myLocation[0]
                    postVC.superVC = self
                    self.present(postVC, animated: true, completion:nil)
                } else {
                   self.dismiss(animated: true, completion: nil)
                }
            })
            
        } else {
            let postVC  = self.storyboard?.instantiateViewController(withIdentifier: "locatorVC") as! AskLocationViewController
            postVC.superVC = self
            self.present(postVC, animated: true, completion:nil)
        }
        
    }
    
    @objc private func refreshBtnClicked()
    {
        refreshData()
    }
    func refreshData()
    {
        ParseClient.sharedInstance().fetchStudentLocations { (success, responseData, error) in
            if(success && responseData != nil)
            {
                let responseData = responseData as! [String:Any]
                let results = responseData["results"] as! [[String:Any]]
                StudentLocation.studentLocations(results: results)
                performOnMainthread {
                    NotificationCenter.default.post(name: Notification.Name(rawValue:"refresh"), object: nil)
                }
            }
            else
            {
                showAlertwith(title: "Failed!", message: "Unable to Authenticate", vc: self)
            }
        }
    }

}
