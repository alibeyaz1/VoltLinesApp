//
// Annotation.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    let identifier: Int?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(identifier: Int? = 0, title: String? = "", coordinate: CLLocationCoordinate2D, image: UIImage? = UIImage()) {
        self.identifier = identifier
        self.title = title
        self.coordinate = coordinate
        self.image = image
    }
}

