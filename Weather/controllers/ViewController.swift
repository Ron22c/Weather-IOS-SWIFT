//
//  ViewController.swift
//  Weather
//
//  Created by Ranajit Chandra on 16/02/20.
//  Copyright © 2020 Ranajit Chandra. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    let WEATHER_URL = "http://openweathermap.org/data/2.5/weather"
    let APP_ID = "b6907d289e10d714a6e88b30761fae22"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempImage: UIImageView!
    @IBOutlet var cityName: UILabel!
    
    @IBAction func tempSwitch(_ sender: UISwitch) {
        print("SWITCH PRESSED")
    }
    
    @IBAction func nextView(_ sender: UIButton) {
        performSegue(withIdentifier: "GotoSecond", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    //MARK: - NETWORKING
    //*******************
    
    func getWeatherData(url:String, parameters:[String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if(response.result.isSuccess){
                let weatherData: JSON = JSON(response.result.value!)
                self.deserializeWeatherData(JSON: weatherData)
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.cityName.text = "connection Issue"
            }
        }
    }
    
    func deserializeWeatherData(JSON: JSON) {
        if let temparature = JSON["main"]["temp"].double {
            print(JSON)
            let city = JSON["name"]
            let condition = JSON["weather"][0]["id"]
            weatherDataModel.temparature = Int(temparature)
            weatherDataModel.city = city.stringValue
            weatherDataModel.condition = condition.intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIconName(condition: weatherDataModel.condition)
            updateUIElements()
        } else {
            cityName.text = "Temparature Unavailable"
        }
    }
    
    func updateUIElements() {
        cityName.text = weatherDataModel.city
        tempLabel.text = String(weatherDataModel.temparature)
        tempImage.image = UIImage(named:weatherDataModel.weatherIconName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let params : [String: String] = ["lat": String(latitude), "lon": String(longitude), "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityName.text = "Location Unavailable"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoSecond" {
            let secondView = segue.destination as! CityController
            secondView.delegate = self
        }
    }
    
    func userEnteredCityName(city: String) {
        let params :[String:String] = ["q":city, "appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
}
