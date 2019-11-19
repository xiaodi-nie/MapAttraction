//
//  PinDetailViewController.swift
//  MapAttraction
//
//  Created by codeplus on 11/11/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class PinDetailViewController: UIViewController {
    //passed from UserPinViewController
    var xid:String = ""
    func getDetailsFromDB(xid : String){
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
                if (id == xid){
                    print(key, tag, description, rating)
                }
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    func getDetailsFromAPI (xid : String){
        let headers = [
            "x-rapidapi-host": "opentripmap-places-v1.p.rapidapi.com",
            "x-rapidapi-key": "8af0d82f43msh34e53305797a0cbp197d01jsnac77d9f76adc"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://opentripmap-places-v1.p.rapidapi.com/en/places/xid/" + xid)! as URL,
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
                  print(json)
                    let feature = json["bbox"]
                   print(json["name"])
                    if let address : NSDictionary = json["address"] as! NSDictionary {
                    print(address["house_number"],address["road"],address["city"],address["state"],address["country"])
                    }
                   print(json["kinds"])
                    if let wiki : NSDictionary = json["wikipedia_extracts"] as? NSDictionary {
                    print(wiki["text"])
                    }
                   print(json["rate"])
                   print(json["image"])
               } catch {
                   print("JSON error: \(error.localizedDescription)")
               }
            }
        })
        dataTask.resume()
    }
    
    func isNumeric(a: String) -> Bool {
      return Double(a) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("passed xid: \(xid)")
        
        if (isNumeric(a: xid)){
            getDetailsFromDB(xid: xid)
        }
        else{
            getDetailsFromAPI(xid: xid)
        }
        

        // Do any additional setup after loading the view.
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
