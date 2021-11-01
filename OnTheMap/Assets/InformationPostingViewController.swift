//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var yourLocationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Actions
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        addYourLocation()
    }
    
    
    // MARK: Variables
    var yourCoordinate : CLLocationCoordinate2D!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        geocoderActive(false)
    }
    
    
    // MARK: Function to find the location (Including performSegue...)
    func addYourLocation(){
        let geocoder = CLGeocoder()
        print("addLocationActivated")
        geocoderActive(true)
        //Find location from word...
        geocoder.geocodeAddressString(self.yourLocationTextField.text ?? "", completionHandler: {(placemarks, error) in
            if let unwrapPlacemarks = placemarks{
                if let firstPlacemark = unwrapPlacemarks.first {
                    if let location = firstPlacemark.location {
                        let targetCoordinate = location.coordinate
                        
                        //memorizing the coordinate for Segue
                        self.yourCoordinate = targetCoordinate
                        self.geocoderActive(false)
                        self.performSegue(withIdentifier: "FindLocationTapped", sender: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Could not find the location coordinate you suggested.", message: error?.localizedDescription ?? "")
                    self.geocoderActive(false)
                }
            }
            
        })
    }
    func geocoderActive(_ active: Bool){
        if active {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        yourLocationTextField.isEnabled = !active
        linkTextField.isEnabled = !active
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindLocationTapped" {
            let addVC = segue.destination as! AddLocationViewController
            addVC.yourLocation = yourLocationTextField.text ?? ""
            addVC.yourLink = linkTextField.text ?? ""
            addVC.yourCoordinate = yourCoordinate
        }
    }
    
}

