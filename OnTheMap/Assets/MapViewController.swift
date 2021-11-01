//
//  MapViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var addInfoButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshTapped(_ sender:UIBarButtonItem){
        print("refreshbuttonTapped")
        getStudentLocationHandler()
    }
    
    
    var studentLocation = [results]()
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //find studentlocation
        getStudentLocationHandler()
    }
    
    func getStudentLocationHandler(){
        studentLocation.removeAll()
        annotations.removeAll()
        OTMClient.gettingStudentLocation(options: "limit=100&order=-updatedAt"){ response, error in
            if let response = response {
                self.studentLocation = response.results
                //print(self.studentLocation)
                self.annotationsHandler()
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.annotations)
                }
            } else {
                self.showAlert(title: "Could not find students data", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func annotationsHandler(){
        mapView.removeAnnotations(mapView.annotations)// removing old annotations
        for location in self.studentLocation {
            let lat = CLLocationDegrees(Double(location.latitude))
            let long = CLLocationDegrees(Double(location.longitude))
            
            //create CLLocationCoordinate1D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaULR = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first), \(last)"
            annotation.subtitle = mediaULR
            
            self.annotations.append(annotation)
        }
    }
    
    
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            openLink(url: (view.annotation?.subtitle!)!)
        }
    }


}


