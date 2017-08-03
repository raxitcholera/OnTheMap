//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/17/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let AuthorizationURL = "https://www.udacity.com/api/session"
        static let UserInfo = "https://www.udacity.com/api/users/{UserID}"
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let StudentLocationWithPostID = "/StudentLocation/{PostID}"
    }
    struct RequestQueryKeys {
        static let UniqueKey = "uniqueKey"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Session = "session"
        static let StudentID = "id"
        static let CreatedDate = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Lat = "latitude"
        static let Long = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedDate = "updatedAt"
        static let Results = "results"
        
    }
}
