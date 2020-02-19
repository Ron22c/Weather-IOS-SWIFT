//
//  CityController.swift
//  Weather
//
//  Created by Ranajit Chandra on 16/02/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredCityName(city: String)
}

class CityController: UIViewController {

    var delegate: ChangeCityDelegate?
    @IBOutlet var textCity: UITextField!
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cityButton(_ sender: UIButton) {
        print("BUTTON PRESSED")
        let city = textCity.text
        delegate?.userEnteredCityName(city: city!)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }
}
