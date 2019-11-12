//
//  PinAnnotation.swift
//  MapAttraction
//
//  Created by codeplus on 11/12/19.
//  Copyright © 2019 yuqiao liang. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let xid: String
    let coordinate: CLLocationCoordinate2D
      
    init(title: String, xid: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.xid = xid
        self.coordinate = coordinate
        
        super.init()
    }
      
    
}

