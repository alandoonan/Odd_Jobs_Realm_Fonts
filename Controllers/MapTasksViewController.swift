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
    
    //Search Bar Vars
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    //IB Outlets
    @IBOutlet weak var searchLocationsResults: UITableView!
    
//    @IBAction func searchButton(_ sender: Any) {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.delegate = self
//        present(searchController, animated: true, completion: nil)
//    }
    
    @IBAction func backToPersonalButton(_ sender: Any) {
        print("Back to Personal Button Pressed")
        performSegueToReturnBack()
    }

    @IBOutlet weak var mapView: MKMapView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self

//        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
//        mapView.delegate = self
//        mapView.setRegion(coordinateRegion, animated: true)
//        mapView.backgroundColor = Themes.current.background
//        view.backgroundColor = Themes.current.background
//        UINavigationBar.appearance().barTintColor = Themes.current.background
        applyTheme(searchLocationsResults,view)
        searchLocationsResults.separatorStyle = UITableViewCell.SeparatorStyle.none
//        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
//        let realm = try! Realm(configuration: config!)
//        let mapItems = realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Personal")
//        super.viewDidLoad()
//        mapView.delegate = self
//        populateMap(mapItems)
//        zoomLevel(location: locationString)
//        searchInMap()

    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return Themes.current.preferredStatusBarStyle
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        applyThemeView(view)
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
//
//    func populateMap(_ mapItems: Results<OddJobItem>) {
//        var maxLongitude = 0.0
//        var maxLatitude = 0.0
//        for mapItem in mapItems {
//            if (mapItem.Latitude != 0) && (mapItem.Longitude != 0) {
//                if mapItem.Latitude > maxLatitude {
//                    maxLatitude = mapItem.Latitude
//                }
//                if mapItem.Longitude > maxLongitude {
//                    maxLongitude = mapItem.Longitude
//                }
//                let mapArt = MapItem(title: mapItem.Name,
//                                     locationName: mapItem.Location,
//                                     discipline: "Test",
//                                     coordinate: CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude))
//                mapView.addAnnotation(mapArt)
//                let location = CLLocationCoordinate2D(latitude: mapItem.Latitude,
//                                                      longitude: mapItem.Longitude)
//                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                let region = MKCoordinateRegion(center: location, span: span)
//                //let coord = CLLocationCoordinate2D(latitude: mapItem.Latitude, longitude: mapItem.Longitude);
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location
//                annotation.title = mapItem.Name
//                annotation.subtitle = mapItem.Location
//                mapView.setRegion(region, animated: true)
//                //mapView.addAnnotation(annotation)
//                //print(coord)
//                //print(maxLongitude,maxLatitude)
//            }
//        }
//    }
//    func zoomLevel(location: CLLocation) {
//        let mapCoords = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
//        mapView.setRegion(mapCoords, animated: true)
//    }
//}
//
//extension MapTasksViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? MapItem else { return nil }
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
//                 calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! MapItem
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
//    }

    
    
//    func getMultipleCoords(addressArray: [String]) {
//        for item in addressArray {
//            getCoordinates(address: item)
//        }
//    }
    
    
    
//    func searchInMap() {
//        var addressArray = [String]()
//        // 1
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "69 Monastery Drive"
//        // 2
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
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
    
//    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        if let title = title {
//            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            annotation.title = title
//            mapView.addAnnotation(annotation)
//        }
//    }
//}
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


extension MapTasksViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
}

extension MapTasksViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        print(searchResults)
        searchLocationsResults.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension MapTasksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.orangeTheme
        cell.selectionStyle = .none
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        //cell.accessoryType = searchResult. ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        return cell
    }
    
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
}

extension MapTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let itemAddress = String(response?.mapItems[0].placemark.subThoroughfare ?? "") + " " + String(response?.mapItems[0].placemark.thoroughfare ?? "")
            print(String(itemAddress))
            print(String(describing: coordinate))
        }
    }
}
