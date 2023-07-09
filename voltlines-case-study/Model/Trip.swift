//
//  Trip.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import UIKit

//struct Trip: Codable {
//    var busName: String?
//    var idBus: Int?
//    var time: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case busName = "bus_name"
//        case idBus = "id"
//        case time = "time"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        busName = try values.decodeIfPresent(String.self, forKey: .busName)
//        idBus = try values.decodeIfPresent(Int.self, forKey: .idBus)
//        time = try values.decodeIfPresent(String.self, forKey: .time)
//    }
//}


//public class Trip: Codable {
//    public var idBus: Int
//    public var busName: String
//    public var time: String
//
//    public init(idBus: Int, busName: String, time: String) {
//        self.idBus = idBus
//        self.busName = busName
//        self.time = time
//    }
//}

struct Trip: Codable {
    var busName: String?
    var id: Int?
    var time: String?
    
    enum CodingKeys: String, CodingKey {
        case busName = "busName"
        case id = "idBus"
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        busName = try values.decodeIfPresent(String.self, forKey: .busName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }
}
