//
//  HistoryItem.swift
//  CallMe
//
//  Created by Luca Lancellotti on 28/07/22.
//

import Foundation
import UIKit

class HistoryItem {
    enum ItemType {
        case camera
        case phone
    }

    var time: String
    var image: UIImage
    var name: String
    var description: String
    var type: ItemType?
    var new: Bool
    var alarm: Bool

    var buttonImage: UIImage? {
        switch type {
        case .camera:
            return UIImage(named: "HistoryButtonCam")
        case .phone:
            return UIImage(named: "PhoneAction")
        case .none:
            return nil
        }
    }

    init(time: String, image: UIImage, name: String, description: String, type: ItemType? = nil, new: Bool = false, alarm: Bool = false) {
        self.time = time
        self.image = image
        self.name = name
        self.description = description
        self.type = type
        self.new = new
        self.alarm = alarm
    }
}
