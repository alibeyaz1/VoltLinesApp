//
//  APIManager.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit
import Alamofire

class APIManager {
    
    static let sharedManager = APIManager()
    private var sessionManager = Session()
    private init() { }
    
    
    fileprivate let encoding = JSONEncoding.default
    
    func getStationList(success: @escaping ((_ status: [Station])-> Void), errorHandler: @escaping ((_ status: Bool)-> Void)){
        
        let endpoint = Globals.shared.stationsEndPoint
        sessionManager.request(endpoint, method: .get, encoding: JSONEncoding.default).responseData { (response) in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let responseArray = try JSONDecoder().decode([Station].self, from: data)
                    success(responseArray)
                } catch  {
                    errorHandler(true)
                }
            case .failure(_ ):
                errorHandler(true)
            }
        }
    }
    
    func bookingTrip(route: Int, station: Int, success: @escaping ((_ status: Trip)-> Void), errorHandler: @escaping ((_ status: Bool)-> Void)){
        
        let endpoint = "https://demo.voltlines.com/case-study/6/stations/\(route)/trips/\(station)"
        sessionManager.request(endpoint, method: .post, encoding: JSONEncoding.default).responseData { (response) in
            let result = response.result
            switch result {
            case .success(let data):
                do {
                    let responseArray = try JSONDecoder().decode(Trip.self, from: data)
                    success(responseArray)
                    print(responseArray.idBus)
                } catch  {
                    errorHandler(true)
                }
            case .failure(_ ):
                errorHandler(true)
            }
        }
    }
}

