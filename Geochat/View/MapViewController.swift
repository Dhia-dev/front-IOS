//
//  MapViewController.swift
//  Geochat
//
//  Created by Apple Esprit on 14/12/2021.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {
    
    // vars
    
    let locationManager = CLLocationManager()
    let myPin = MKPointAnnotation()
    
    // outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveLocationButton.isEnabled = false
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleTap(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SecondModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // protocols
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            
            pinAnnotationView.tintColor = UIColor(named: "accentColor")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }
    
    // methods
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.state != UITapGestureRecognizer.State.began{
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            saveLocationButton.isEnabled = true
           
            myPin.coordinate = locationCoordinate
            
            myPin.title = "Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude)
            
            mapView.addAnnotation(myPin)
        }
    }
    
    // actions
    
    @IBAction func addUserLocation(_ sender: Any) {
        UserViewModel().getUserFromToken(userToken: UserDefaults.standard.string(forKey: "userToken")!) { [self] success, user in
            if success {
                UserViewModel().setPosition(email: (user?.email)!, latitude: myPin.coordinate.latitude, longitude: myPin.coordinate.longitude, clear: false) { success in
                    if success {
                        let action = UIAlertAction(title: "Profile", style: .default) { uiAction in
                            self.dismiss(animated: true, completion: nil)
                        }
                    
                        
                        self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Location saved !", action: action),animated: true)
                    } else {
                        self.present(Alert.makeAlert(titre: "Error", message: "Could not save location"),animated: true)
                    }
                }
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not retrieve user from token"),animated: true)
            }
    }
}
    // addUserLocation
    }
