//
//  Artwork.swift
//  Odd Jobs Beta
//
//  Created by Alan Doonan on 04/05/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import MapKit
import Contacts

class MapItem: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let pin: UIColor
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, pin: UIColor) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.pin = pin
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
