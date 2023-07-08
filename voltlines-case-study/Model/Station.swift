//
//  Station.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import UIKit

public class Station: Decodable {
    public var id: Int
    public var name: String
    public var centerCoordinates: String
    public var trips: [Trip]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case centerCoordinates = "center_coordinates"
        case trips
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        centerCoordinates = try container.decode(String.self, forKey: .centerCoordinates)
        trips = try container.decode([Trip].self, forKey: .trips)
    }
}

