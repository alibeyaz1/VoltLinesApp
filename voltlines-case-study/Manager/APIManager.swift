//
// APIManager.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 07.07.2023.
//

import Foundation
import Alamofire

class APIManager {
    
    static let sharedManager = APIManager()
    private var sessionManager = Session()
    private init() { }
    
    
    fileprivate let encoding = JSONEncoding.default
    
    // Fetch station list from the server
    func getStationList(success: @escaping ((_ status: [StationItem])-> Void), errorHandler: @escaping ((_ status: Bool)-> Void)){
        
        let endpoint = "https://demo.voltlines.com/case-study/6/stations"
        
        // Make a GET request to the endpoint
        sessionManager.request(endpoint, method: .get, encoding: JSONEncoding.default).responseData { (response) in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let responseArray = try JSONDecoder().decode([StationItem].self, from: data)
                    success(responseArray)
                } catch  {
                    errorHandler(true)
                }
            case .failure(_ ):
                errorHandler(true)
            }
        }
    }
    // Book a trip with the given route and station

    func bookingTrip(route: Int, station: Int, success: @escaping ((_ status: BookingResponse)-> Void), errorHandler: @escaping ((_ status: Bool)-> Void)){
        
        let endpoint = "https://demo.voltlines.com/case-study/6/stations/\(route)/trips/\(station)"
        
        // Make a POST request to the endpoint
        sessionManager.request(endpoint, method: .post, encoding: JSONEncoding.default).responseData { (response) in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let responseArray = try JSONDecoder().decode(BookingResponse.self, from: data)
                    success(responseArray)
                } catch  {
                    errorHandler(true)
                }
            case .failure(_ ):
                errorHandler(true)
            }
        }
    }
}

