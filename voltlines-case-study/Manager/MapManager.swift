//
// MapManager.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 07.07.2023.
//

import Foundation
import CoreLocation

class MapManager {
    
    var didFetchedCoordinates: (([MapStation]) -> Void)?
    var didSelectedLine: ((MapStation) -> Void)?
    var coordinatesList = [MapStation]()
    
    var bookedTrip = Int()
    var bookedStation: TripItem?
    
    func fetchLinesList() {
        APIManager.sharedManager.getStationList { (response) in
            if response.count > 0 {
                let stationList = response.map { stationItem in
                    if let selectedStation = stationItem.trips?.first(where: {$0.id == self.bookedTrip}) {
                        self.bookedStation = selectedStation
                    }
                    
                    return MapStation(
                        coordinates: stationItem.center_coordinates,
                        id: stationItem.id,
                        name: stationItem.name,
                        trips: stationItem.trips,
                        booked: (stationItem.trips?.first(where: {$0.id == self.bookedTrip}) != nil)
                    )
                    
                }
                self.coordinatesList = stationList
                self.didFetchedCoordinates?(stationList)
            }
        } errorHandler: { (error) in
            print(error == true ? "error" : "success")
        }
    }
    
    func didSelectedLine(_ id: Int) {
        if let selectedTrip = coordinatesList.first(where: {$0.id == id}) {
            self.didSelectedLine?(selectedTrip)
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
