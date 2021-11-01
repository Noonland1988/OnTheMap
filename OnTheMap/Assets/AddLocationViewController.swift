//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    
    
    //MARK: Variables, Constants
    
    var yourLocation = ""
    var yourLink = ""
    var yourCoordinate: CLLocationCoordinate2D!

    
    //MARK: Actions
    @IBAction func finishTapped(_ sender:UIButton) {
            geocoderActive(true)
        OTMClient.createStudentLocation(yourLocation: yourLocation, yourLink: linkcheck(link: yourLink), yourLatitude: Float(yourCoordinate.latitude), yourLongitude: Float(yourCoordinate.longitude)){ success, error in
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
    

    //MARK: Life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        geocoderActive(false)
        addYourPinOnTheMap()
    }
    
    func addYourPinOnTheMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = yourCoordinate
        pin.title = self.yourLocation
        self.Map.addAnnotation(pin)
        self.Map.region = MKCoordinateRegion(center: yourCoordinate, latitudinalMeters:  500.0, longitudinalMeters: 500.0)
    }
    
    
    func geocoderActive(_ active: Bool){
        active ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        finishButton.isEnabled = !active
    }
    
    func linkcheck(link: String) -> String{
        return link.contains("https://") ? link : "https://" + link
    }

        
    

}
