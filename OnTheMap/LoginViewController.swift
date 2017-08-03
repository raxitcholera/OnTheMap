//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginBtn: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtUserName.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        if(txtUserName.text?.isEmpty == false && txtPassword.text?.isEmpty == false)
        {
            loginBtn.isEnabled = false
            ParseClient.sharedInstance().loginWithCredentials(userName: txtUserName.text!, password: txtPassword.text!, apiCompletionHandler: { (responseData, error) in
                performOnMainthread{
                    self.loginBtn.isEnabled = true
                }
                if let result = responseData as? NSDictionary {
                    self.appDelegate.uniqueKey = result.value(forKeyPath: "account.key") as? String
                    let parameters = [String:AnyObject]()
                    ParseClient.sharedInstance().getUserInfo(ParseClient.Constants.UserInfo,parameters: parameters, completionHandlerForGET: { (responseData, error) in
                        if let response = responseData as? NSDictionary{
                            self.appDelegate.firstName = response.value(forKeyPath: "user.first_name") as? String
                            self.appDelegate.LastName = response.value(forKeyPath: "user.last_name") as? String
                            
                            performOnMainthread {
                                let mainTabView = self.storyboard?.instantiateViewController(withIdentifier: "mainTabViewController") as! MainViewController
                                self.navigationController?.pushViewController(mainTabView, animated: true)
                            }

                        } else {
                            performOnMainthread {
                                showAlertwith(title: "Failed to Fetch User Info", message: error?.localizedDescription, vc: self)
                            }
                        }
                        
                    })
                    
                }else {
                    performOnMainthread {
                        showAlertwith(title: "Failed to Authenticate", message: "The User name or Password is Incorrect", vc: self)
                    }
                }
                
            })
        }
            
        else
        {
            showAlertwith(title: "Username and Password are mandatory", message: "", vc: self)
        }
    
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
