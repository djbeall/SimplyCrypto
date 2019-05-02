//
//  TrackCurrencyViewController.swift
//  SimplyCrypto
//
//  Created by Daniel Beall on 5/1/19.
//  Copyright © 2019 Group18. All rights reserved.
//

import UIKit

class TrackCurrencyViewController: UIViewController{
    
    
    @IBOutlet weak var currencyAmount: UITextField!
    @IBOutlet weak var currencyValue: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var trackingButtonOutlet: UIButton!
    
    
    @IBAction func trackingAction(_ sender: UIButton) {
        var amountDict = UserDefaults.standard.dictionary(forKey: "Amount") ?? [:]
        var valueDict = UserDefaults.standard.dictionary(forKey: "Value") ?? [:]
        amountDict[currentCurrency!] = Double(currencyAmount.text!)
        valueDict[currentCurrency!] = Double(currencyValue.text!)

        UserDefaults.standard.set(amountDict, forKey: "Amount")
        UserDefaults.standard.set(valueDict, forKey: "Value")
        navigationController?.popViewController(animated: true)        
    }
    var currentCurrency: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        trackingButtonOutlet.isEnabled = false
        currencyLabel.text = currentCurrency
        trackingButtonOutlet.layer.cornerRadius = 10
        currencyAmount.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        currencyValue.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
    }
    
    @objc func textFieldChange() {
        if let _ = Double(currencyAmount.text!), let _ = Double(currencyValue.text!) {
            trackingButtonOutlet.isEnabled = true
        } else {
            trackingButtonOutlet.isEnabled = false
        }
    }
    

}
