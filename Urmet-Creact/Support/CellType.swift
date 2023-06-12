//
//  CellType.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import Foundation

enum CellType: Int {
    case titleWithRightSwitch
    case titleWithRightButton
    case iconTitleSubtitle
    case headerTitle
    case field // Field full width
    case fieldWithLeftCheckbox // Left checkbox, right field
    case fieldWithCheckboxLeftArrow
    case rightField //Title left, right checkbox
    case picker //Title left, right picker
}
