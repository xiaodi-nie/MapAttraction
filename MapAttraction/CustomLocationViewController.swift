//
//  CustomLocationViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/4/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var customMap: MKMapView!
    
    let locationManager = CLLocationManager()
    let customPin = MKPointAnnotation()
    //var pinView: MKAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'
        
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        // Do any additional setup after loading the view.
        customMap.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if(status == .authorizedWhenInUse || status == .authorizedAlways){
        manager.requestLocation()
      }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        customMap.removeAnnotation(customPin)
        if let userLocation = locations.last{
            let x = userLocation.coordinate.latitude
            let y = userLocation.coordinate.longitude
            print("latitude = \(x)")
            print("longitude = \(y)")
            
            let currCoords = CLLocationCoordinate2D(latitude: x, longitude: y)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: currCoords, span: span)
            customMap.setRegion(region, animated: true)

            
            customPin.coordinate = currCoords
            customPin.title = "(\(x), \(y))"
            customMap.addAnnotation(customPin)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")

            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true

            return pinAnnotationView
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation{
                let newx = droppedAt.coordinate.latitude
                let newy = droppedAt.coordinate.longitude
                print("\(newx), \(newy)")
                self.customPin.title = "(\(newx), \(newy))"
            }
            
        }
    }
    
    
}


