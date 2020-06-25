//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var weatherMaster: WeatherMaster?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //request for permission to access location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        cityTextField.delegate = self
        weatherMaster = WeatherMaster()
        weatherMaster?.delegate = self
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: -LocationManager extension

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude 
            let long = location.coordinate.longitude
            weatherMaster?.fetchWeather(lat: lat, lon: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: -WeatherDelegate

extension WeatherViewController: WeatherDelegate{
    
    func didUpdateWeather(_ weatherMaster: WeatherMaster, weather: WeatherModel) {
        print(weather.cityName)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.condition)
        }
    }
    
    func didFailWithError(_ weatherMaster: WeatherMaster, error: Error) {
        print(error)
    }
    
}

//MARK: -UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = cityTextField.text {
            weatherMaster?.fetchWeather(city: city)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        textField.placeholder = ""
        return false
    }
    
    @IBAction func searchCityPressed(_ sender: UIButton) {
        cityTextField.endEditing(true)
    }
    
}
