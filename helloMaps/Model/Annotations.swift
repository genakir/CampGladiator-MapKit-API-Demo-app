//
//  Annotations.swift
//  helloMaps
//
//  Created by Gennadii Kiryushatov on 10/29/20.
//  Copyright © 2020 Gennadii Kiryushatov. All rights reserved.
//

import MapKit
import AddressBook

class Annotations: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
}
