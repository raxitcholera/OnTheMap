//
//  AskLinkViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AskLinkViewController: UIViewController, UITextFieldDelegate {

    //to store my information
    var myLocation:StudentLocation?
    //to find where to return too
    var superVC:MainViewController!
    
    
    var searchString:String?
    var lat:Double?
    var long:Double?
    
    
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaURL.delegate = self
        postBtn.isEnabled = false
    }

    @IBAction func cancelClicked(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SearchForLocation()
    }
    
    @IBAction func postBtnClicked(_ sender: Any) {
        var parameters = [String:AnyObject]()
        parameters["firstName"] = self.appDelegate.firstName as AnyObject
        parameters["lastName"] = self.appDelegate.LastName as AnyObject
        parameters["mediaURL"] = mediaURL.text as AnyObject
        parameters["mapString"] = searchString as AnyObject
        parameters["latitude"] = lat as AnyObject
        parameters["longitude"] = long as AnyObject
        
        
        if myLocation?.objectId != nil{
            
            ParseClient.sharedInstance().updateStudentLocation(parameters, postId: (myLocation?.objectId)!) { (success, resule, error) in
                if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.superVC.refreshData()
                } else {
                    showAlertwith(title: "Error Updating Location", message: "Check Network and try again", vc: self)
                }
            }
        } else {
            ParseClient.sharedInstance().postStudentLocation(parameters) { (success, resule, error) in
            if success {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    self.superVC.refreshData()
                } else {
                    showAlertwith(title: "Error Updating Location", message: "Check Network and try again", vc: self)
                }
            }
        }
    
    }
    
    func SearchForLocation() {
        startNetworkinUseIndicator()
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchString
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            
            
            if localSearchResponse == nil{
                showAlertwith(title: "Location Not found", message: "Go back and Try again", vc: self)
                self.dismiss(animated: true, completion: nil)
                return 
            }
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = "\(String(describing: self.appDelegate.firstName!)) \(String(describing: self.appDelegate.LastName!))"
            self.lat = localSearchResponse!.boundingRegion.center.latitude
            self.long = localSearchResponse!.boundingRegion.center.longitude
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = pointAnnotation.coordinate
            self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 2000, 2000), animated: true)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
            
            stopNetworkinUseIndicator()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if mediaURL.isFirstResponder && !(mediaURL.text?.isEmpty)! && !UIApplication.shared.canOpenURL(URL(string: mediaURL.text!)!) {
            showAlertwith(title: "Url Invalid", message: "Check the MediaURL", vc: self)
            mediaURL.text = ""
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !(mediaURL.text?.isEmpty)! && lat != nil && long != nil {
            postBtn.isEnabled = true
        }
        return true
    }

    

    

}
