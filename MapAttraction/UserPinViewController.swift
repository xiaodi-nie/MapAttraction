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

class UserPinViewController: UIViewController,UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var coordinates:[(Double,Double)] = []
    
    //variables passed from the filterViewController
    var passedFilterTags:[String] = []
    var passedFilterDistance:Int = 0
    var passedFilterRating:Int = 0
    
    var annotationLocations = [
        ["title": "location 1", "latitude": 37.33627815, "longitude": -122.03096498, "xid":"xid111", "fromApi": false],
        ["title": "location 2", "latitude": 37.33198570, "longitude": -122.02952778, "xid":"xid222", "fromApi": false]
    ]
    
    var annotationLocationsDb = [
        ["title": "location 1", "latitude": 37.33627815, "longitude": -122.03096498, "xid":"xid111", "fromApi": false],
        ["title": "location 2", "latitude": 37.33198570, "longitude": -122.02952778, "xid":"xid222", "fromApi": false]
    ]
    
    //variables used to record current coordinates
    var lastLat:Double = 0
    var lastLong:Double = 0
    var maxla:Double = 0
    var minla:Double = 0
    var maxlong:Double = 0
    var minlong:Double = 0
    
    typealias FinishedDownload = () -> ()
    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func unwindFromSubmitVC(segue:UIStoryboardSegue) {
        let currCoords = CLLocationCoordinate2D(latitude: lastLat, longitude: lastLong)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: currCoords, span: span)
        //myMap.setRegion(region, animated: true)
        
        minla = region.center.latitude - (region.span.latitudeDelta / 2.0);
        
        maxla = region.center.latitude + (region.span.latitudeDelta / 2.0);
        minlong = region.center.longitude - (region.span.longitudeDelta / 2.0);
        maxlong = region.center.longitude + (region.span.longitudeDelta / 2.0);
        //print("\(minlong) \(maxlong) \(minla) \(maxla)")

        
        // get data with boarding boundary from api and parse the result into annotationLocations
        let defaulturl = "https://opentripmap-places-v1.p.rapidapi.com/en/places/bbox?lon_min="+String(minlong)+"&lon_max="+String(maxlong)+"&lat_min="+String(minla)+"&lat_max="+String(maxla)
        
        //print(defaulturl)
        getFromAPI(urlrequest: defaulturl)
        //pinLocations(locations: annotationLocations)
        getLocationFromDBWithInRange(minX: minla, maxX: maxla, minY: minlong, maxY: maxlong, ratingMin: -1, tags: [])
    }
    
    //destination of the unwind segue linked to the cancel button on the filterViewController
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
    //destination of the unwind segue linked to the Apply button on the filterViewController
    @IBAction func unwindFromFilterVC(_ sender: UIStoryboardSegue){
        if sender.source is FilterViewController{
            if let senderVC = sender.source as? FilterViewController{
                passedFilterTags = senderVC.filterTags
                passedFilterDistance = senderVC.filterDistance
                passedFilterRating = senderVC.filterRating
                
                //lon1 + atan2(sin(θ)*sin(d/R)*cos(lat1), cos(d/R)−sin(lat1)*sin(lat2))
                var minLong : Double = lastLong - 0.000089982311916*Double(passedFilterDistance)*cos(lastLat * Double.pi/180)
                print(minLong)
                var maxLong : Double = lastLong + 0.000089982311916*Double(passedFilterDistance)*cos(lastLat * Double.pi/180)
                print(maxLong)
                var minLat : Double = lastLat - 0.000089982311916*Double(passedFilterDistance)
                print(minLat)
                var maxLat : Double = lastLat + 0.000089982311916*Double(passedFilterDistance)
                print(maxLat)
                print("\(passedFilterTags) \(passedFilterDistance) \(passedFilterRating)")
                // call api with filter
                // pin the result from the api
                var requesturl = "https://opentripmap-places-v1.p.rapidapi.com/en/places/bbox?"
                var i = 0
                if(passedFilterRating == 0 && passedFilterDistance == 0 && passedFilterTags.count == 0){
                    let currCoords = CLLocationCoordinate2D(latitude: lastLat, longitude: lastLong)
                    let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                    let region = MKCoordinateRegion(center: currCoords, span: span)
                    //myMap.setRegion(region, animated: true)
                    
                    minla = region.center.latitude - (region.span.latitudeDelta / 2.0);
                    
                    maxla = region.center.latitude + (region.span.latitudeDelta / 2.0);
                    minlong = region.center.longitude - (region.span.longitudeDelta / 2.0);
                    maxlong = region.center.longitude + (region.span.longitudeDelta / 2.0);
                   
                    // get data with boarding boundary from api and parse the result into annotationLocations
                    let defaulturl = "https://opentripmap-places-v1.p.rapidapi.com/en/places/bbox?lon_min="+String(minlong)+"&lon_max="+String(maxlong)+"&lat_min="+String(minla)+"&lat_max="+String(maxla)
                    print(defaulturl)
                    getFromAPI(urlrequest: defaulturl)
                    getLocationFromDBWithInRange(minX: minla, maxX: maxla, minY: minlong, maxY: maxlong, ratingMin: -1, tags: [])
                    return
                }
                if(passedFilterTags.count != 0){
                    requesturl += "kinds="
                    for tag in passedFilterTags{
                        i += 1
                        requesturl = requesturl + tag
                        if(i < passedFilterTags.count){
                            requesturl = requesturl + ","
                        }
                    }
                }

                if(passedFilterRating != 0){
                    requesturl += "&rate="+String(passedFilterRating)
                }
                
                if(passedFilterDistance != 0){
                    requesturl += "&lon_min="+String(minLong)+"&lon_max="+String(maxLong)+"&lat_min="+String(minLat)+"&lat_max="+String(maxLat)
                }
                else{
                    //give a default box as min lat, max lat, max long and min long
                    requesturl += "&lon_min="+String(minlong)+"&lon_max="+String(maxlong)+"&lat_min="+String(minla)+"&lat_max="+String(maxla)
                }
                getFromAPI(urlrequest: requesturl)
                getLocationFromDBWithInRange(minX: minla, maxX: maxla, minY: minlong, maxY: maxlong, ratingMin: passedFilterRating, tags:passedFilterTags)
                //pinLocations(locations: self.annotationLocations)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'
        
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        //the following code snippet is used to enable touching anywhere on the screen to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        searchBar.showsScopeBar = true
        searchBar.delegate = self
    }
    
    
    


    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(name: searchBar.text! )
        
    }

    
    
    
    
    
    
    //called after the search button on keyboard is pressed
    func getData(name :String){
        self.annotationLocationsDb.removeAll()
        print(name)
        myMap.removeAnnotations(myMap.annotations)
        print("after clear: \(self.annotationLocationsDb)")
                let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
         ref.child("locations").observeSingleEvent(of: .value, with: { (snapshot) in
             for child in snapshot.children{
                 let snap = child as! DataSnapshot
                 let key = snap.key
                 let value = snap.value!
                 let info = value as! NSDictionary
                 let id :String  = info["xid"] as! String
                 let tag : [String] = info["tag"] as! [String]
                 let description : String = info["description"] as! String
                 let rating : Int = info["rating"] as! Int
                 let x :Double = Double(info["x"] as! Double)
                 let y :Double = Double(info["y"] as! Double)
                if (key.contains(name)){
                      print("yes key is" , key)
                     self.annotationLocationsDb.append(["title": key, "latitude": x, "longitude": y, "xid":id, "fromApi": false])
                 }
             }
            self.pinLocations(locations:self.annotationLocationsDb)
         })
         { (error) in
             print(error.localizedDescription)
         }


        
    }
    
    
    //pin annotations to the map
    func pinLocations(locations:[[String:Any]]){
        for location in locations{
            let coord = CLLocationCoordinate2DMake(location["latitude"] as! CLLocationDegrees, location["longitude"] as! CLLocationDegrees)
            let annotation = PinAnnotation(title: location["title"] as! String, xid: location["xid"] as! String, coordinate: coord)
            myMap.addAnnotation(annotation)
        }
    }
    
    //called after an annotation is clicked on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
            performSegue(withIdentifier: "toPinDetailSegue", sender: view)
        }
        
    }
    
    //called after user location is acquired/updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        print("in location manager")
        if let userLocation = locations.last{
            self.lastLat = userLocation.coordinate.latitude
            self.lastLong = userLocation.coordinate.longitude
        
            let currCoords = CLLocationCoordinate2D(latitude: lastLat, longitude: lastLong)
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: currCoords, span: span)
            myMap.setRegion(region, animated: true)
            
            minla = region.center.latitude - (region.span.latitudeDelta / 2.0);
            
            maxla = region.center.latitude + (region.span.latitudeDelta / 2.0);
            minlong = region.center.longitude - (region.span.longitudeDelta / 2.0);
            maxlong = region.center.longitude + (region.span.longitudeDelta / 2.0);
            //print("\(minlong) \(maxlong) \(minla) \(maxla)")

            
            // get data with boarding boundary from api and parse the result into annotationLocations
            let defaulturl = "https://opentripmap-places-v1.p.rapidapi.com/en/places/bbox?lon_min="+String(minlong)+"&lon_max="+String(maxlong)+"&lat_min="+String(minla)+"&lat_max="+String(maxla)
            
            //print(defaulturl)
            getFromAPI(urlrequest: defaulturl)
            //pinLocations(locations: annotationLocations)
            getLocationFromDBWithInRange(minX: minla, maxX: maxla, minY: minlong, maxY: maxlong, ratingMin: -1, tags: [])
        
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPinDetailSegue" )
        {
            let destVC = segue.destination as! PinDetailViewController
            destVC.xid = ((sender as! MKAnnotationView).annotation as! PinAnnotation).xid
        }
    }
    
    // operate with api
    
    func getFromAPI (urlrequest:String){
        // clear the annotationlocation list
        print("url: \(urlrequest)")
        self.annotationLocations.removeAll()
        myMap.removeAnnotations(myMap.annotations)

 
        let headers = [
            "x-rapidapi-host": "opentripmap-places-v1.p.rapidapi.com",
            "x-rapidapi-key": "8af0d82f43msh34e53305797a0cbp197d01jsnac77d9f76adc"
            //"x-rapidapi-key": "SIGN-UP-FOR-KEY"
        ]
        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://opentripmap-places-v1.p.rapidapi.com/en/places/bbox?lon_min=100&lon_max=100&lat_min=100&lat_max=100")! as URL,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
        let request = NSMutableURLRequest(url: NSURL(string: urlrequest)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let json: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    if (json != nil && json["features"] != nil) {
                    let feature: NSArray = json["features"] as! NSArray
                    //print("feature:\(feature)")
                    for item in feature{
                        
                        let detail = item as! NSDictionary
                        let geometry = detail["geometry"] as! NSDictionary
                        let coordinates = geometry["coordinates"] as! NSArray
                        let long: Double = coordinates[0] as! Double
                        let lat: Double = coordinates[1] as! Double
                        let properties = detail["properties"] as! NSDictionary
                        let name: String = properties["name"]! as! String
                        let rate: Double = properties["rate"]! as! Double
                        let xid: String = properties["xid"]! as! String
//                        print(name+"->", xid+"->", String(rate)+"->",String(long)+"->",String(lat))
//                        print(name)
//                        print(lat)
//                        print(long)
                        self.annotationLocations.append(["title": name, "latitude": lat, "longitude": long, "xid":xid, "fromApi": true])
                        
                    }
                   // print("in getfromapi \(self.annotationLocations)")
                    self.pinLocations(locations: self.annotationLocations)
                    }
                    else{
                        print("API result is empty")
                        print(json)
                    }
                    } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        })
        
        dataTask.resume()
        //print(self.annotationLocations)
        
       
    }
    
    func getLocationFromDBWithInRange(minX: Double, maxX: Double, minY: Double, maxY: Double,ratingMin: Int, tags: [String] ) {
        print("minx: \(minX), maxx:\(maxX), miny:\(minY),maxy:\(maxY)")
        // clear all annotationLocation list
        self.annotationLocationsDb.removeAll()
        let ref = Database.database().reference(fromURL: "https://mapattraction.firebaseio.com/")
        ref.child("locations").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value!
                let info = value as! NSDictionary
                let id  = info["xid"]
                let kinds : [String] = info["tag"] as![String]
                let rating:Int = Int(info["rating"] as! Int)
                let x :Double = Double(info["x"] as! Double)
                let y :Double = Double(info["y"] as! Double)
                
                for kind in kinds{
                    if (x <= maxX && x >= minX && y >= minY && y <= maxY && rating >= ratingMin && (tags.contains(kind) || tags.isEmpty) ){
                    self.annotationLocationsDb.append(["title": key, "latitude": x, "longitude": y, "xid":id, "fromApi": false])
                }
                }
            }
            print("in getdatafromdb \(self.annotationLocationsDb)")
            self.pinLocations(locations: self.annotationLocationsDb)
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    

}
