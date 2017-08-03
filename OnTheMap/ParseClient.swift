//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/17/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func loginWithCredentials(userName: String, password: String, apiCompletionHandler: @escaping ResutOrError)
    {
        let arguemntString = "{\"udacity\":{\"username\": \"\(userName)\", \"password\": \"\(password)\"}}"
        let url = URL(string: Constants.AuthorizationURL)
        
        let jsonData = arguemntString.data(using: String.Encoding.utf8)

        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        processTask(request as URLRequest, applyOffset:true, completionHandlerForProcessingTask: apiCompletionHandler)

    }
    
    
    func getUserInfo(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping ResutOrError) {
        let url = URL(string: substituteKeyInMethod(Constants.UserInfo, key: "UserID", value: self.appDelegate.uniqueKey!)!)
        let request = generateRequestOf(type: "GET", url: url)
        
        processTask(request as URLRequest, applyOffset:true, completionHandlerForProcessingTask: completionHandlerForGET)
        
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping ResutOrError) {
        
        let request = generateRequestOf(type: "GET", url: URLFromParameters(parameters,withPathExtension: method))
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForGET)
        
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping ResutOrError) {
        let tempParameter = [String:AnyObject]()
        let request = generateRequestOf(type: "POST", url: URLFromParameters(tempParameter, withPathExtension: method))
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForPOST)
        
    }
    
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping ResutOrError) {
        let tempParameter = [String:AnyObject]()
        let request = generateRequestOf(type: "PUT", url: URLFromParameters(tempParameter, withPathExtension: method))
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForPOST)
        
    }
    
    func deleteSession(with apiCompletionHandler: @escaping ResutOrError){
        let url = URL(string: Constants.AuthorizationURL)
        let request = generateRequestOf(type: "DELETE", url: url)
        
        processTask(request as URLRequest, applyOffset:true,completionHandlerForProcessingTask: apiCompletionHandler)
        
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    //process the Task created
    
    private func processTask(_ request: URLRequest, applyOffset:Bool,  completionHandlerForProcessingTask: @escaping ResutOrError)
    {
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
    
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForProcessingTask(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
    
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error?.localizedDescription))")
                return
            }
    
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("There was an Error response from the Server")
                return
            }
    
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
    
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, applyOffset: applyOffset, completionHandlerForConvertData: completionHandlerForProcessingTask)
        }
    
        /* 7. Start the request */
        task.resume()

    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, applyOffset:Bool, completionHandlerForConvertData: ResutOrError) {
        
        var parsedResult: AnyObject! = nil
        do {
            var parsedString = String.init(data: data, encoding: String.Encoding.utf8)
            
            if(applyOffset)
            {
                let startIndex = parsedString?.index((parsedString?.startIndex)!, offsetBy: 5)
                parsedString = parsedString?.substring(from: startIndex!)
            }
            
            let jsonData = parsedString?.data(using: String.Encoding.utf8)
            
            parsedResult = try JSONSerialization.jsonObject(with: jsonData!, options: [.allowFragments,.mutableContainers,.mutableLeaves]) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func URLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }
    
    func stringFromParam (_ parameters:[String:AnyObject])-> String {
        var outputString = String()
        
        for(key,value) in parameters{
            var value1 = String()
            
            if key == "longitude" || key == "latitude" {
                value1 = String(describing: value)
            } else {
                value1 = "\"\(value)\""
            }
            
            if (outputString.isEmpty){
                
                outputString = "\"\(key)\":\(value1)"
            } else {
                outputString = "\(String(describing: outputString)),\"\(key)\":\(value1)"
            }
        }
        
        return outputString
    }
    
    func fetchStudentLocations(with apiCompletionHandler: @escaping APICompletionHandler){
        var orderParameters = [String:AnyObject]()
        orderParameters["order"] = "-updatedAt" as AnyObject
        orderParameters["limit"] = 100 as AnyObject
        
        startNetworkinUseIndicator()
        taskForGETMethod(Methods.StudentLocation, parameters: orderParameters, completionHandlerForGET: { (responseData, error) in
            if(responseData != nil)
            {
                apiCompletionHandler(true, responseData, nil)
            }
            else
            {
                apiCompletionHandler(false,nil, error)
            }
            stopNetworkinUseIndicator()
        })
        
    }
    func postPID(_ parameters:[String:AnyObject], with apiCompletionHandler:@escaping ResutOrError){
        var parameters = parameters
        parameters["pid"] = "4" as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        startNetworkinUseIndicator()
        
        let request = NSMutableURLRequest(url: URL(string: "http://localhost/~raxit/SP1/api/user.stock.list.php")!)
        request.httpMethod = "POST"
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: apiCompletionHandler)
        stopNetworkinUseIndicator()
    }
    
    func postStudentLocation(_ parameters:[String:AnyObject], with apiCompletionHandler:@escaping APICompletionHandler){
        var parameters = parameters
        parameters["uniqueKey"] = appDelegate.uniqueKey as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        startNetworkinUseIndicator()
        taskForPOSTMethod(Methods.StudentLocation, parameters: parameters, jsonBody: jsonBody) { (responseData, error) in
            if(responseData != nil){
                apiCompletionHandler(true,responseData,nil)
            } else {
                apiCompletionHandler(false,nil,error)
            }
            stopNetworkinUseIndicator()
        }
    }
    func updateStudentLocation(_ parameters:[String:AnyObject], postId:String, with apiCompletionHandler:@escaping APICompletionHandler){
        var parameters = parameters
        parameters["uniqueKey"] = appDelegate.uniqueKey as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        startNetworkinUseIndicator()
        taskForPUTMethod(substituteKeyInMethod(Methods.StudentLocationWithPostID, key: "PostID", value: postId)! , parameters: parameters, jsonBody: jsonBody) { (responseData, error) in
            if(responseData != nil){
                apiCompletionHandler(true,responseData,nil)
            } else {
                apiCompletionHandler(false,nil,error)
            }
            stopNetworkinUseIndicator()
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
