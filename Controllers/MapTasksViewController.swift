//
//  MapViewController.swift
//  
//
//  Created by Alan Doonan on 23/07/2019.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation

class MapTasksViewController: UIViewController {
    
    //IB Outlets
    @IBAction func backToPersonalButton(_ sender: Any) {
        print("Back to Personal Button Pressed")
        performSegueToReturnBack()
    }
    @IBOutlet weak var mapView: MKMapView!

    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 20000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        let mapItems = realm.objects(OddJobItem.self).filter("Category in %@ and IsDone == false", Constants.listTypes)
        checkLocationServices()
        populateMap(mapItems)
        view.backgroundColor = Themes.current.background
        UINavigationBar.appearance().barTintColor = Themes.current.background
        mapView.backgroundColor = Themes.current.background
        applyThemeView(view)
        
        //searchInMap()
        }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
}


extension MapTasksViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func getCoordinates(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            print("Printing Coords")
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)
    }

    func populateMap(_ mapItems: Results<OddJobItem>) {
        var maxLongitude = 0.0
        var maxLatitude = 0.0
        for mapItem in mapItems {
            if (mapItem.Latitude != 0) && (mapItem.Longitude != 0) {
                var pin = UIColor()
                if mapItem.Latitude > maxLatitude {
                    maxLatitude = mapItem.Latitude
                }
                if mapItem.Longitude > maxLongitude {
                    maxLongitude = mapItem.Longitude
                }
                if mapItem.Category == "Personal" {
                    pin = UIColor.orangeTheme
                }
                if mapItem.Category == "Group" {
                    pin = UIColor.blueTheme
                }
                if mapItem.Category == "Life" {
                    pin = UIColor.greenTheme
                }
                print(pin)
                let mapArt = MapItem(title: mapItem.Name,
                                     locationName: mapItem.Location,
                                     discipline: "Test",
                                     coordinate: CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude), pin: pin)
                mapView.addAnnotation(mapArt)
            }
        }
    }
}

extension MapTasksViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapItem else { return nil }
        let identifier = "marker"
        var view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            //view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
//        let size = CGSize(width: 20, height: 20)
//        UIGraphicsBeginImageContext(size)
//        annotation.pin.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        //view.image = resizedImage
        view.markerTintColor = annotation.pin
        
        return view
    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? MapItem else { return nil }
//        let identifier = "marker"
//        var view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            //view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        let size = CGSize(width: 20, height: 20)
//        UIGraphicsBeginImageContext(size)
//        annotation.pin.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        view.image = resizedImage
//        return view
//    }
    
    

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapItem
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }

    func getMultipleCoords(addressArray: [String]) {
        for item in addressArray {
            getCoordinates(address: item)
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

//extension MapTasksViewController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        searchCompleter.queryFragment = searchText
//    }
//}

//extension MapTasksViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let searchResult = searchResults[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//
//        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        cell.backgroundColor = Themes.current.background
//        cell.selectionStyle = .none
//        cell.tintColor = .white
//        cell.textLabel?.textColor = Themes.current.accent
//        cell.detailTextLabel?.textColor = .white
//        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
//        cell.textLabel?.text = searchResult.title
//        cell.detailTextLabel?.text = searchResult.subtitle
//        //cell.accessoryType = searchResult. ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
//
//        return cell
//    }


//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // Add animations here
//        cell.alpha = 0
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.05 * Double(indexPath.row),
//            animations: {
//                cell.alpha = 1
//        })
//    }
//}
//
//extension MapTasksViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("SELECTING ROW")
//
//        let completion = searchResults[indexPath.row]
//        let searchRequest = MKLocalSearch.Request(completion: completion)
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { (response, error) in
//            let coordinate = response?.mapItems[0].placemark.coordinate
//            let itemAddress = String(response?.mapItems[0].placemark.subThoroughfare ?? "") + " " + String(response?.mapItems[0].placemark.thoroughfare ?? "")
//            print(String(itemAddress))
//            print(String(describing: coordinate))
//        }
//    }
//}




//    func searchInMap() {
//        var addressArray = [String]()
//        // 1
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "69 Monastery Drive"
//        // 2
//        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//        request.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
//        // 3
//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            guard let response = response else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error").")
//                return
//            }
//            for item in response.mapItems {
//                let itemAddress = String(item.placemark.subThoroughfare ?? "") + " " + String(item.placemark.thoroughfare ?? "")
////                print("ITEM ADDRESS")
//                //print(itemAddress)
//                addressArray.append(String(itemAddress))
//            }
//            print(addressArray.count)
//            print("GUARD ADDRESS ARRAY.")
//            print(addressArray)
//            //self.getMultipleCoords(addressArray: [String]())
//        }
//    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//        //Ignoring user
//        UIApplication.shared.beginIgnoringInteractionEvents()
//
//        //Activity Indicator
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.style = UIActivityIndicatorView.Style.gray
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
//        self.view.addSubview(activityIndicator)
//        //Hide search bar
//        searchBar.resignFirstResponder()
//        dismiss(animated: true, completion: nil)
//        //Create the search request
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = searchBar.text
//        let activeSearch = MKLocalSearch(request: searchRequest)
//        activeSearch.start { (response, error) in
//            activityIndicator.stopAnimating()
//            UIApplication.shared.endIgnoringInteractionEvents()
//            if response == nil
//            {
//                print("ERROR")
//            }
//            else
//            {
//                //Remove annotations
//                let annotations = self.mapView.annotations
//                self.mapView.removeAnnotations(annotations)
//                //Getting data
//                let latitude = response?.boundingRegion.center.latitude
//                let longitude = response?.boundingRegion.center.longitude
//                //Create annotation
//                let annotation = MKPointAnnotation()
//                annotation.title = searchBar.text
//                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
//                self.mapView.addAnnotation(annotation)
//                //Zooming in on annotation
//                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
//                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//                let region = MKCoordinateRegion(center: coordinate, span: span)
//                self.mapView.setRegion(region, animated: true)
//            }
//        }
//    }

