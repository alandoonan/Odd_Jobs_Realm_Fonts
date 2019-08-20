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
    
    //Test Data
    let initialLocation = CLLocation(latitude: 53.322065, longitude: -6.386767)
    let searchRadius: CLLocationDistance = 2000
    let locationString = CLLocation(latitude: 53.322191, longitude: -7.386739)
    let distanceSpan: CLLocationDistance = 150000
    
    @IBAction func backToPersonalButton(_ sender: Any) {
        print("Back to Personal Button Pressed")
        performSegueToReturnBack()
    }

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.delegate = self
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.backgroundColor = Themes.current.background
        view.backgroundColor = Themes.current.background
        UINavigationBar.appearance().barTintColor = Themes.current.background
        searchInMap()
        applyThemeView(view)
        
//
//        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
//        let realm = try! Realm(configuration: config!)
//        let mapItems = realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Personal")
//        super.viewDidLoad()
//        mapView.delegate = self
//        populateMap(mapItems)
//        zoomLevel(location: locationString)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func populateMap(_ mapItems: Results<OddJobItem>) {
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
                let mapArt = MapItem(title: mapItem.Name,
                                     locationName: mapItem.Location,
                                     discipline: "Test",
                                     coordinate: CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude))
                mapView.addAnnotation(mapArt)
                let location = CLLocationCoordinate2D(latitude: mapItem.Latitude,
                                                      longitude: mapItem.Longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: location, span: span)
                //let coord = CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude);
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = mapItem.Name
                annotation.subtitle = mapItem.Location
                mapView.setRegion(region, animated: true)
                //mapView.addAnnotation(annotation)
                //print(coord)
                print(maxLongitude,maxLatitude)
            }
        }
    }
    func zoomLevel(location: CLLocation) {
        let mapCoords = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        mapView.setRegion(mapCoords, animated: true)
    }
}

extension MapTasksViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapItem else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapItem
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func searchInMap() {
        // 1
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Chinese"
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
        // 3
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            for item in response.mapItems {
                print(item.name!)
                print(item.phoneNumber ?? "No phone number.")
            }
        }
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            
            mapView.addAnnotation(annotation)
        }
    }
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
