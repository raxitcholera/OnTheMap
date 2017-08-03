//
//  AskLocationViewController.swift
//  OnTheMap
//
//  Created by Raxit Cholera on 6/16/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class AskLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    
    //to store my information
    var myLocation:StudentLocation?
    //to find where to return too
    var superVC:MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationClicked(_ sender: Any) {
        if (locationTextField.text?.isEmpty)! {
            showAlertwith(title: "Location can not be empty", message: "Please Mention your Location", vc: self)
        } else {
            let linkVC = storyboard?.instantiateViewController(withIdentifier: "asklinkVC") as! AskLinkViewController
            if myLocation != nil {
                linkVC.myLocation = myLocation
            }
            linkVC.superVC = superVC
            linkVC.searchString = locationTextField.text
            present(linkVC, animated: true, completion:nil)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
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
