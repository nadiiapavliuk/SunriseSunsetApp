//
//  PlacePickerViewController.swift
//  SunriseSunsetApp
//
//  Created by Nadiia Pavliuk on 6/22/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

import GooglePlacePicker
import GoogleMaps

class PlacePickerViewController: UIViewController, GMSPlacePickerViewControllerDelegate  {

    var location: String?
    fileprivate let urlPath = "https://api.sunrise-sunset.org/json"
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    
    
    
    @IBAction func pickPlace(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        print("?lat=\(place.coordinate.latitude)&lng=\(place.coordinate.longitude)")
        location = "?lat=\(place.coordinate.latitude)&lng=\(place.coordinate.longitude)"
        downloadJSON(location!) {}
        nameLabel.text = "Name: " + place.name
        addressLabel.text = "Address: " + (place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))!
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        NSLog("An error occurred while picking a place: \(error)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        nameLabel.text = "No place selected"
    }
  
    
    func downloadJSON(_ location: String, completed: @escaping () -> ()) {
        guard let url = URL(string: "\(urlPath)\(location)") else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(Root.self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.sunsetLabel?.text = "Sunset: " + result.results.sunset!
                        self.sunriseLabel?.text = "Sunrise: " + result.results.sunrise!
                        completed()
                    }
                } catch {
                    print("Error \(error)")
                }
            }
            
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
