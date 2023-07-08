//
//  MapStation.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation


//class CustomModel {
//    var coordinates: String?
//    var id: Int?
//    var name: String?
//    var trips: [TripItem]?
//    var booked: Bool?
//
//    var tripInfo: String {
//        let tripCount = trips?.count.string ?? Constants.kEmpty
//        return tripCount == Constants.kEmpty ? Constants.kEmpty : String(format: Constants.kTripInfo, tripCount)
//    }
//}



struct MapStation {
    var coordinates: String?
    var id: Int?
    var name: String?
    var trips: [Trip]?
    var booked: Bool?
    
    var tripInfo: String {
        let tripCount = trips?.count.string ?? ""
        return tripCount == "" ? "" : String(format: "%@ Trips", tripCount)
    }
}



//public class MapStation {
//    public var id: Int?
//    public var name: String?
//    public var coordinates: String?
//    public var trips: [Trip]?
//    public var booked: Bool?
//
//    var tripInfo: String {
//        let tripCount = trips?.count.string ?? ""
//        return tripCount == "" ? "" : String(format: "%@ Trips", tripCount)
//    }

//    init(coordinates: String?, id: Int?, name: String?, trips: [Trip]?, booked: Bool?) {
//        self.coordinates = coordinates
//        self.id = id
//        self.name = name
//        self.trips = trips
//        self.booked = booked
//    }

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
