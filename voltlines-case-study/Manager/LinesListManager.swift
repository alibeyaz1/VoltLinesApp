//
//  LinesListManager.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 07.07.2023.
//

import Foundation

class LinesListManager {
    
    var didListUpdated: (() -> Void)? // Closure called when the list is updated
    var didBookedTrip: ((Int) -> Void)? // Closure called when a trip is successfully booked
    var didFailedBookTrip: (() -> Void)? // Closure called when booking a trip fails
    
    var didFetchedStationList: (([MapStation]) -> Void)? // Closure called when the station list is fetched
    
    var sectionListSource = [LinesListSection]()
    var selectedTrips = MapStation()
    
    func generateTripList() {
        if let trips = selectedTrips.trips, trips.count > 0 {
            var list = [LinesListSection]()
            
            for (index, item) in trips.enumerated() {
                // Create line items for each trip
                list.append(LinesListSection(items: [
                    LineItem(id: item.id, lineName: item.bus_name, lineTime: item.time)]))
            }
            
            self.sectionListSource = list
            self.didListUpdated?()
        }
    }
    
    func bookSelectedTrip(_ id: Int) {
        // Book a selected trip using the API manager
        APIManager.sharedManager.bookingTrip(route: selectedTrips.id ?? 0, station: id) { (response) in
            if let id = response.id, id != 400 {
                self.didBookedTrip?(id) // Notify successful booking
            }
            else {
                self.didFailedBookTrip?() // Notify failed booking
                
            }
        } errorHandler: { (error) in
            self.didFailedBookTrip?() // Notify failed booking
            
            //        } errorHandler: { (error) in
            //        }
        }
    }
}
extension LinesListManager {
    func rowCount(_ section: Int) -> Int{
        let data = self.sectionListSource[section]
        if let itemCount = data.itemCount {
            return itemCount
        } else {
            return data.items?.count ?? 0
        }
    }
}
