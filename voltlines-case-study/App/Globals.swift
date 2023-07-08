//
//  Globals.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation

class Globals{
    
    static let shared = Globals()
    
    var stationsEndPoint = "https://demo.voltlines.com/case-study/6/stations"
    
    static let kEmpty = ""
    static let kComma = ","
    static let kBook = "Book"
    static let kRoutes = "Routes"
    static let kListTrips = "List Trips"
    static let kTripInfo = "%@ Trips"
    static let kUserMarker = "userMarker"
    static let kBookedMarker = "bookedMarker"
    static let kDefaultMarker = "defaultMarker"
    static let kAlertTitle = "The trip you selected is full."
    static let kAlertDesc = "Please selected another one."
    static let kAlertBtn = "Select a Trip"
}
