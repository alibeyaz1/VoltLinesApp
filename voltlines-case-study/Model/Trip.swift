//
//  Trip.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import UIKit

public class Trip: Codable {
    public var idBus: Int
    public var busName: String
    public var time: String

    public init(idBus: Int, busName: String, time: String) {
        self.idBus = idBus
        self.busName = busName
        self.time = time
    }
}
