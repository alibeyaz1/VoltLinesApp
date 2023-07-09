//
//  MapStation.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation

struct MapStation {
    var coordinates: String?
    var id: Int?
    var name: String?
    var trips: [TripItem]?
    var booked: Bool?
    
    var tripInfo: String {
        let tripCount = trips?.count.string ?? ""
        return tripCount == "" ? "" : String(format: "%@ Trips", tripCount)
    }
}
