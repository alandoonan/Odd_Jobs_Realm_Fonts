//
//  MapViewController.swift
//  
//
//  Created by Alan Doonan on 23/07/2019.
//

import UIKit
import MapKit
import RealmSwift

class MapTasksViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        let mapItems = realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Personal")
        super.viewDidLoad()
        populateMap(mapItems)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    fileprivate func populateMap(_ mapItems: Results<OddJobItem>) {
        var maxLongitude = 0.0
        var maxLatitude = 0.0
        for mapItem in mapItems {
            if (mapItem.Latitude != 0) && (mapItem.Longitude != 0) {
                if mapItem.Latitude > maxLatitude {
                    maxLatitude = mapItem.Latitude
                }
                if mapItem.Longitude > maxLongitude {
                    maxLongitude = mapItem.Longitude
                }
                let locationString = CLLocation(latitude: 53.322191, longitude: -7.386739)
                let distanceSpan: CLLocationDistance = 5000
                let location = CLLocationCoordinate2D(latitude: mapItem.Latitude,
                                                      longitude: mapItem.Longitude)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: location, span: span)
                let coord = CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude);
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = mapItem.Name
                annotation.subtitle = mapItem.Location
                mapView.setRegion(region, animated: true)
                mapView.addAnnotation(annotation)
                print(coord)
        print(maxLongitude,maxLatitude)
                
                func zoomLevel(location: CLLocation) {
                    let mapCoords = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
                    mapView.setRegion(mapCoords, animated: true)
                }
            }
            
            
        }
    }
}
