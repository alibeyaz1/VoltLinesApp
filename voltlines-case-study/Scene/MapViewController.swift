//
//  MapViewController.swift
//  VoltLinesChallenge
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: VoltLinesViewController {
    
    // MARK: - Properties
    
    // Instance of MapManager for handling map-related operations
    var manager: MapManager = { () in
        .init()
    }()
    
    // Map view to display the map
    let vwMap = MKMapView()
    
    // Button to show a list of lines
    lazy var btnList = CustomButton()
    
    // Location manager for managing user's location
    var locationManager: CLLocationManager = CLLocationManager()
    
    // Route ID of the selected line
    var routeId = Int()
    
    // ID of the booked route
    var bookedRoute = Int()
    
    // Latitude and longitude of the user's current location
    var userLong = Double()
    var userLat = Double()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkLocationPermissions()
        initManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        setupLocationManager()
        initManager()
    }
    
    // MARK: - View Setup
    
    // Sets up the initial view hierarchy
    func setupView() {
        
        view.addSubview(vwMap)
        view.addSubview(btnList)
     
        
        vwMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnList.layer.cornerRadius = 28
        btnList.clipsToBounds = true
        btnList.delegate = self
        btnList.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(52)
        }
        btnList.hideButton()
    }
    
    // Initializes the MapManager and sets the necessary callbacks
    func initManager() {
        manager.bookedTrip = bookedRoute
        
        // Callback when coordinates are fetched from the server
        manager.didFetchedCoordinates = { list in
            self.setStations(list)
        }
        
        // Callback when a line is selected from the list
        manager.didSelectedLine = { line in
            DispatchQueue.main.async {
                let lineVc = LinesListViewController()
                let nav = UINavigationController(rootViewController: lineVc)
                lineVc.line = line
                lineVc.delegate = self
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    // MARK: - Location Handling
    
    // Checks the location permissions and requests authorization if needed
    private func checkLocationPermissions() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        } else if authorizationStatus == .authorizedWhenInUse {
            DispatchQueue.main.async {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
        
        setupLocationManager()
    }
    
    // Sets up the location manager and starts updating the user's location
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        manager.fetchLinesList()
    }
}

// MARK: - Extensions

extension MapViewController {
    
    // MARK: - Map Handling
    
    // Sets the user's location on the map
    private func setLocation(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        vwMap.setRegion(region, animated: true)
        vwMap.delegate = self
        vwMap.mapType = MKMapType.standard
        vwMap.mapType = .standard
        vwMap.isZoomEnabled = true
        vwMap.isScrollEnabled = true
        
        if let coor = vwMap.userLocation.location?.coordinate {
            vwMap.setCenter(coor, animated: true)
        }
        
        let userAnnotation = Annotation(
            coordinate: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            image: UIImage(named: "Selected Point"))
        
        vwMap.addAnnotation(userAnnotation)
    }
    
    // Sets the stations on the map using the fetched data
    private func setStations(_ data: [MapStation]) {
        data.forEach { station in
            if let coordinate = station.coordinates {
                let coordinates = coordinate.components(separatedBy: ",")
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(
                    Double(coordinates[0]) ?? 0.0,
                    Double(coordinates[1]) ?? 0.0
                )
                
                let annotation = Annotation(
                    identifier: station.id ?? 0,
                    title: station.tripInfo,
                    coordinate: location,
                    image: station.booked == true ? UIImage(named: "Completed") : UIImage(named: "Point"))
                
                vwMap.addAnnotation(annotation)
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[locations.count - 1]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        self.userLat = lat
        self.userLong = long
        setLocation(CLLocation(latitude: lat, longitude: long))
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    // Called when an annotation is selected on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            let identifier = annotation.identifier ?? 0
            self.routeId = identifier
            self.btnList.showButton()
        }
    }
    
    // Configures the view for each annotation on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else { return nil }
        let reuseIdentifier = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = annotation.image
        return annotationView
    }
    
    // Called when the map region changes
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.btnList.hideButton()
    }
    
    // Configures the renderer for overlays on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.lightGray
        renderer.lineWidth = 4.0
        return renderer
    }
}

// MARK: - CustomButtonDelegate

extension MapViewController: CustomButtonDelegate {
    
    // Called when the custom button is tapped
    func didTappedCustomButton() {
        self.manager.didSelectedLine(routeId)
    }
}

// MARK: - LinesListViewControllerDelegate

extension MapViewController: LinesListViewControllerDelegate {
    
    // Called when a trip is booked
    func didBookedTrip(_ id: Int) {
        self.bookedRoute = id
        self.manager.fetchLinesList()
    }
}
