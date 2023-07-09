//
//  StationsListResponse.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation

struct StationsListResponse: Codable {
    var stations: [StationItem]?
    
    enum CodingKeys: String, CodingKey {
        case stations = "stations"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stations = try values.decodeIfPresent([StationItem].self, forKey: .stations)
    }
}

struct StationItem: Codable {
    var center_coordinates: String?
    var id: Int?
    var name: String?
    var trips: [TripItem]?
    
    enum CodingKeys: String, CodingKey {
        case center_coordinates = "center_coordinates"
        case id = "id"
        case name = "name"
        case trips = "trips"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        center_coordinates = try values.decodeIfPresent(String.self, forKey: .center_coordinates)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        trips = try values.decodeIfPresent([TripItem].self, forKey: .trips)
    }
}


struct TripItem: Codable {
    var bus_name: String?
    var id: Int?
    var time: String?
    
    enum CodingKeys: String, CodingKey {
        case bus_name = "bus_name"
        case id = "id"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bus_name = try values.decodeIfPresent(String.self, forKey: .bus_name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }
}
