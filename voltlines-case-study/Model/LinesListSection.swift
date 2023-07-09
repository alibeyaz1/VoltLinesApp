//
//  LinesListSection.swift
// voltlines-case-study
//
//  Created by Ali Beyaz on 8.07.2023.
//

import UIKit

class LinesListSection {
    var type: LinesListSectionType
    var items: [Any]?
    var itemCount: Int?
    
    init(type: LinesListSectionType, items: [Any]? = nil, itemCount: Int? = nil) {
        self.type = type
        self.items = items
        self.itemCount = itemCount
    }
}
