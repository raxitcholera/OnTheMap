//
//  ParseConvinience.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/17/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation

extension ParseClient
{
    func generateRequestOf(type: String!, url: URL!) -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = type
        
        if(type == "DELETE")
        {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies!
            {
                if cookie.name == "XSRF-TOKEN"
                {
                    xsrfCookie = cookie
                    
                    break
                }
            }
            
            if let xsrfCookie = xsrfCookie
            {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
            
        else
        {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        return request
    }
    
    
}
