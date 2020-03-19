//
//  SecondViewController.swift
//  Clock_FinalProject
//
//  Created by Bijay Maharjan on 12/3/19.
//  Copyright © 2019 Bijay Maharjan. All rights reserved.
//

import UIKit

// Create protocol to pass data between views.
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class SecondViewController: UIViewController {
    
    // Declare delegate.
    var delegate: ChangeCityDelegate?

    // Textfield
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    // Button pressed.
    @IBAction func getDataPressed(_ sender: AnyObject) {
        
        // Get city name.
        let cityName = changeCityTextField.text!
        // Call delegate
        delegate?.userEnteredANewCityName(city: cityName)
        // Go back to main screen.
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Cancel and go back.
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
