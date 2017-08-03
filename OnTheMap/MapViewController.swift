//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name(rawValue:"refresh"), object: nil)
        // Do any additional setup after loading the view.
    }

    
    func refreshView()
    {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in StudentLocation.locations
        {
            let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            
            
            //annotations.append(annotation)
            mapView.addAnnotation(annotation)
//            myMapManager.checkMapBounds(location: coordinate)
        }
        
//        myMapManager.setRegion(mapView: mapView, centerToCurrentLocation: true)
    }
// This is for pin selection and not the view selection
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let strinUrl = view.annotation?.subtitle!! {
//        
//        if let url = URL(string: strinUrl) {
//            // check if your application can open the NSURL instance
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: { (successful) in
//                    
//                })
//            }
//        }
//        }
//    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
            
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = URL(string:(view.annotation?.subtitle!)!) {
                if app.canOpenURL(toOpen){
                    app.open(toOpen, options: [:], completionHandler: { isOpened in
                        
                    })
                }
                else
                {
                    showAlertwith(title: "Invalid!", message: "URL is invalid. Please check the URL", vc: self)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
