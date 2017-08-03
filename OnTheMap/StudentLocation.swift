//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/17/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation

struct StudentLocation
{
    static var locations = [StudentLocation]()
    
    let objectId: String
    let uniqueKey: String
    
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    
    let lat: Double
    let lng: Double
    let createdAt:Date
    let updatedAt:Date
    
    
    private init(dictionary: [String:Any])
    {
        firstName = dictionary["firstName"] as? String ?? ""
        
        lastName = dictionary["lastName"] as? String ?? ""
        mediaURL = dictionary["mediaURL"] as? String ?? ""
        
        mapString = dictionary["mapString"] as? String ?? ""
        lat = dictionary["latitude"] as? Double ?? 0.0
        lng = dictionary["longitude"] as? Double ?? 0.0
        
        objectId = dictionary["objectId"] as? String ?? ""
        uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        
        createdAt = dictionary["createdAt"] as? Date ?? Date()
        updatedAt = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    static func studentLocations(results: [[String:Any]])
    {
        locations.removeAll()
        
        for result in results
        {
            locations.append(StudentLocation(dictionary: result))
        }
    }
    
    private static func getString(string: Any) -> String
    {
        let string = string as! String
        if(string.isEmpty == false)
        {
            return string
        }
            
        else
        {
            return ""
        }
    }
}
