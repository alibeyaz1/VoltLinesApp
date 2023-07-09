//
//  MapVC.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit
import MapKit
import SnapKit

class MapVC : UIViewController{
    
    var mapManager: MapManager = { () in
            .init()
    }()
    
    let mapView =  MKMapView()
    let listButton = CustomButton(title: "List Trips")
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    var routeId = Int()
    var bookedRouteId = Int()
    var userLong = Double()
    var userLat = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkLocationPermissions()
        initPresenter()
    }
    
    private func setupUI() {
        mapView.mapType = .hybrid
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
            
        }
    }
    func initPresenter() {
        mapManager.bookedTrip = bookedRouteId
        mapManager.fetchedCoordinates = { list in
            self.setStations(list)
        }
        
        mapManager.selectedLine = { line in
            DispatchQueue.main.async {
                let lineVc = ListTripVC()
                let nav = UINavigationController(rootViewController: lineVc)
//                lineVc.line = line
//                lineVc.delegate = self
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
        mapManager.fetchLinesList()
    }
}

extension MapVC {
    private func setLocation(_ location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        let userAnnotation = Annotation(
            image: UIImage(named: "SelectedPoint"),
            coordinate: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude))
        mapView.addAnnotation(userAnnotation)
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
                    title: station.name ?? "",
                    image: station.booked == true ? UIImage(named: "SelectedPoint") : UIImage(named: "Point"),
                    identifier: station.id ?? 0,
                    coordinate: location)
                mapView.addAnnotation(annotation)
            }
        }
        if bookedRouteId != 0 {
            routeDraw(userLat, long: userLong)
        }
    }
    
    private func routeDraw(_ lat: Double, long: Double) {
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let stationLoc = mapManager.fetchSelectedStationCoords(bookedRouteId)
        
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
        
        self.mapView.addAnnotation(stationAnotation)
        
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
            self.mapView.addOverlay((route.polyline), level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
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

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            let identifier = annotation.identifier ?? 0
            self.routeId = identifier
            self.listButton.showButton()
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
        self.listButton.hideButton()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.lightGray
        renderer.lineWidth = 4.0
        return renderer
    }
}

extension MapVC: CustomButtonDelegate {
    func didTappedListButton() {
        self.mapManager.selectedLine(routeId)
    }
}

extension MapVC: ListTripVCDelegate {
    func didBookedTrip(_ id: Int) {
        self.bookedRouteId = id
        self.mapManager.fetchLinesList()
    }
}


