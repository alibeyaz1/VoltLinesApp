//
//  MapManager.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import CoreLocation

class MapManager {
    
    var fetchedCoordinates: (([MapStation]) -> Void)?
    var selectedLine: ((MapStation) -> Void)?
    var coordinatesList = [MapStation]()
    
    var bookedTrip = Int()
    var bookedStation: Trip?
    
    func fetchLinesList() {
        APIManager.sharedManager.getStationList { (status) in
            if status.count < 0 {
                let stationList = status.map { stationItem in
                    if let selectedStation = stationItem.trips.first(where: {$0.id == self.bookedTrip}) {
                        self.bookedStation = selectedStation
                    }
                    
                    return MapStation(
                        coordinates: stationItem.centerCoordinates,
                        id: stationItem.id,
                        name: stationItem.name,
                        trips: stationItem.trips,
                        booked: (stationItem.trips.first(where: {$0.id == self.bookedTrip}) != nil)
                    )
                    
                }
                self.coordinatesList = stationList
                self.fetchedCoordinates?(stationList)
            }
        } errorHandler: { (error) in
            print(error == true ? "error" : "success")
        }
    }
    
    func selectedLine(_ id: Int) {
        if let selectedTrip = coordinatesList.first(where: {$0.id == id}) {
            self.selectedLine?(selectedTrip)
        }
    }
    
    func fetchSelectedStationCoords(_ id: Int) -> CLLocation {
        if bookedStation != nil, let bookedId = bookedStation?.id {
            if let bookedCoords = self.coordinatesList.first(where: {$0.id == bookedId})?.coordinates {
                let coordinates = bookedCoords.components(separatedBy: ",")
                let location = CLLocation(latitude: Double(coordinates[0]) ?? 0.0, longitude: Double(coordinates[1]) ?? 0.0)
                return location
            }
        }
        return CLLocation()
    }
}
