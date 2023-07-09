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
    
    var manager: MapManager = { () in
            .init()
    }()
    
    let vwMap = MKMapView()
    lazy var btnList = CustomButton()
    var locationManager: CLLocationManager = CLLocationManager()
    
    var routeId = Int()
    var bookedRoute = Int()
    var userLong = Double()
    var userLat = Double()
    
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
    
    func setupView() {
        view.addViews(views: [
            vwMap,
            btnList
        ])
        
        vwMap.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnList.layer.cornerRadius = 8
        btnList.clipsToBounds = true
        btnList.delegate = self
        btnList.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(52)
        }
        btnList.hideButton()
    }
    
    func initManager() {
        manager.bookedTrip = bookedRoute
        manager.didFetchedCoordinates = { list in
            self.setStations(list)
        }
        
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
    
    private func checkLocationPermissions() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .notDetermined {
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }else if authorizationStatus == .authorizedWhenInUse {
            DispatchQueue.main.async {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        manager.fetchLinesList()
    }
}

extension MapViewController {
    private func setLocation(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        vwMap.setRegion(region, animated: true)
        vwMap.delegate = self
        vwMap.mapType = MKMapType.standard
        vwMap.mapType = .standard
        vwMap.isZoomEnabled = true
        vwMap.isScrollEnabled = true
        
        if let coor = vwMap.userLocation.location?.coordinate{
            vwMap.setCenter(coor, animated: true)
        }
        let userAnnotation = Annotation(
            coordinate: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            image: UIImage(named: "Selected Point"))
        vwMap.addAnnotation(userAnnotation)
    }
    
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
                    title: station.name ?? "",
                    subtitle: station.tripInfo,
                    coordinate: location,
                    image: station.booked == true ? UIImage(named: "Completed") : UIImage(named: "Point"))
                vwMap.addAnnotation(annotation)
            }
        }
        if bookedRoute != 0 {
            routeDraw(userLat, long: userLong)
        }
    }
    
    private func routeDraw(_ lat: Double, long: Double) {
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let stationLoc = manager.fetchSelectedStationCoords(bookedRoute)
        
        let userLocation2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let stationLocation2D = CLLocationCoordinate2D(latitude: Double(stationLoc.coordinate.latitude), longitude: Double(stationLoc.coordinate.longitude))
        
        var distance = userLocation.distance(from: stationLoc)
        if distance > 1000 {
            distance = distance / 1000
            let value = String(distance)
            let result = String(value.prefix(5))
//            self.infoLabel.text = "\(result) km"
        }
        else {
            let value = String(distance)
            let result = String(value.prefix(5))
//            self.infoLabel.text = "\(result) m"
        }
        
        let sourcePlaceMark = MKPlacemark(coordinate: userLocation2D, addressDictionary: nil)
        let stationPlaceMark = MKPlacemark(coordinate: stationLocation2D, addressDictionary: nil)
        
        let stationAnotation = MKPointAnnotation()
        if let stationLoc = stationPlaceMark.location {
            stationAnotation.coordinate = stationLoc.coordinate
        }
        
        self.vwMap.addAnnotation(stationAnotation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: stationPlaceMark)
        directionRequest.transportType = .any
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                }
                return
            }
            let route = directionResponse.routes[0]
            self.vwMap.addOverlay((route.polyline), level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.vwMap.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            let identifier = annotation.identifier ?? 0
            self.routeId = identifier
            self.btnList.showButton()
        }
    }
    
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.btnList.hideButton()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.lightGray
        renderer.lineWidth = 4.0
        return renderer
    }
}

extension MapViewController: CustomButtonDelegate {
    func didTappedCustomButton() {
        self.manager.didSelectedLine(routeId)
    }
}

extension MapViewController: LinesListViewControllerDelegate {
    func didBookedTrip(_ id: Int) {
        self.bookedRoute = id
        self.manager.fetchLinesList()
    }
}
