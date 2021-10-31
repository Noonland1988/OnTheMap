//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func finishTapped(_ sender:UIButton) {
        geocoderActive(true)
        OTMClient.createStudentLocation(yourLocation: yourLocation, yourLink: yourLink, yourLatitude: Float(yourCoordinate.latitude), yourLongitude: Float(yourCoordinate.longitude)){ success, error in
            if success == true {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.geocoderActive(false)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "POST failed", message: error?.localizedDescription ?? "")
                    self.geocoderActive(false)
                }
            }
        }
    }
    
    var yourLocation = ""
    var yourLink = ""
    var yourCoordinate: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addYourLocation()
    }
    
    
    func addYourLocation(){
        let geocoder = CLGeocoder()
        geocoderActive(true)
        //Find location from word...
        geocoder.geocodeAddressString(self.yourLocation, completionHandler: {(placemarks, error) in
            if let unwrapPlacemarks = placemarks{
                if let firstPlacemark = unwrapPlacemarks.first {
                    if let location = firstPlacemark.location {
                        let targetCoordinate = location.coordinate
                        
                        //memorizing the coordinate for POST
                        self.yourCoordinate = targetCoordinate
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = targetCoordinate
                        pin.title = self.yourLocation
                        self.Map.addAnnotation(pin)
                        self.Map.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters:  500.0, longitudinalMeters: 500.0)
                        self.geocoderActive(false)
                    }
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
        finishButton.isEnabled = !active
    }
        
    

}
