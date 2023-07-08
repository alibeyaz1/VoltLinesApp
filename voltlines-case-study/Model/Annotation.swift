//
//  Annotation.swift
//  voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import MapKit

public class Annotation : NSObject, MKAnnotation {
    
    public var title : String?
    public var image : UIImage?
    public var identifier : Int?
    public var coordinate : CLLocationCoordinate2D
    
    public init(title: String? = nil, image: UIImage? = UIImage(), identifier: Int? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.identifier = identifier
        self.coordinate = coordinate
    }
}
