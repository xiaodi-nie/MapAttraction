//
//  UserPinViewController.swift
//  MapAttraction
//
//  Created by Yijie Yan on 11/2/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class UserPinViewController: UIViewController {
    

    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinLocation(a: 36.001678, b: -78.939767)
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        let name = "Frank"
           let age = 23
           let city = "aaa"
           print("aaaadadasd")
           
           ref.child("sss").child(name).updateChildValues(["age": age, "city": city])
        
        // Do any additional setup after loading the view.
        
    }
    func pinLocation(a: Double , b: Double){
        let chapelCoords = CLLocationCoordinate2DMake(a, b)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1 )
        let region = MKCoordinateRegion(center: chapelCoords, span: span)
        myMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = chapelCoords
        annotation.title = "Your Place"
        annotation.subtitle = "Pin your place"
        myMap.addAnnotation(annotation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        if let userLocation = locations.first{
            print("latitude = \(userLocation.coordinate.latitude)")
            print("latitude = \(userLocation.coordinate.longitude)")
            
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

}
