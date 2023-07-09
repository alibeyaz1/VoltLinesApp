//
//  LinesListSection.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class LinesListSection {

    var items: [Any]?
    var itemCount: Int?
    
    init( items: [Any]? = nil, itemCount: Int? = nil) {
        self.items = items
        self.itemCount = itemCount
    }
}
