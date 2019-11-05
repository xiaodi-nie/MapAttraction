//
//  ViewController.swift
//  MapAttraction
//
//  Created by yuqiao liang on 10/17/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import UIKit
import Firebase






class ViewController: UIViewController {
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getXid()
        // Do any additional setup after loading the view.

   
   
        
    }
        
    func getXid (){
         let headers = [
             "x-rapidapi-host": "opentripmap-places-v1.p.rapidapi.com",
             "x-rapidapi-key": "8af0d82f43msh34e53305797a0cbp197d01jsnac77d9f76adc"
         ]
         
         let request = NSMutableURLRequest(url: NSURL(string: "https://opentripmap-places-v1.p.rapidapi.com/en/places/radius?radius=500&lat=59.855685&lon=38.364285")! as URL,
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
                     let feature: NSArray = json["features"] as! NSArray
                    // print(feature)
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
                         print(name+"->", xid+"->", String(rate)+"->",String(long)+"->",String(lat))
                     }
                 } catch {
                     print("JSON error: \(error.localizedDescription)")
                 }
             }
         })
         
         dataTask.resume()
    }


}

