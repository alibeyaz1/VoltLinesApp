//
//  LinesListManager.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 07.07.2023.
//

import Foundation

class LinesListManager {
    
    var didListUpdated: (() -> Void)?
    var didBookedTrip: ((Int) -> Void)?
    var didFailedBookTrip: (() -> Void)?
    
    var didFetchedStationList: (([MapStation]) -> Void)?
    
    var sectionListSource = [LinesListSection]()
    var selectedTrips = MapStation()
    
    func generateTripList() {
        if let trips = selectedTrips.trips, trips.count > 0 {
            var list = [LinesListSection]()
            
            for (index, item) in trips.enumerated() {
                list.append(LinesListSection(type: .spacing, items: [4]))
                list.append(LinesListSection(type: .route, items: [
                    LineItem(id: item.id, lineName: item.bus_name, lineTime: item.time)]))
                
                if index < trips.count {
                    list.append(LinesListSection(type: .spacing, items: [4]))
                    list.append(LinesListSection(type: .line, items: [""]))
                }
            }
            self.sectionListSource = list
            self.didListUpdated?()
        }
    }
    
    func bookSelectedTrip(_ id: Int) {
        APIManager.sharedManager.bookingTrip(route: selectedTrips.id ?? 0, station: id) { (response) in
            if let id = response.id, id != 0 {
                self.didBookedTrip?(id)
            }
        } errorHandler: { (error) in
            self.didFailedBookTrip?()
        }
    }
}

extension LinesListManager {
    func rowCount(_ section: Int) -> Int{
        let data = self.sectionListSource[section]
        if let itemCount = data.itemCount {
            return itemCount
        }else {
            return data.items?.count ?? 0
        }
    }
}
