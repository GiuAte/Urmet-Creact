//
//  FormRow.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import Foundation
import UIKit

protocol Taggable: AnyObject {
    var kvcKey: String? { get set }
}

open class BaseRow : NSObject, Taggable {
    public typealias Validator = (() -> Bool)

    var title: String?
    var icon: String?

    // Update object properties using the key with key-value-coding
    var kvcKey: String?

    var fieldType: (any RawRepresentable)?
    var placeholder: String?
    var validator: Validator?
    var regexValidator: String?
    var validationFailed: Bool?
    var validationFailedMessage: String?
    var cellType: CellType?
    var fieldEnabled: Bool?
    var choosingList: [Any]?

    open var baseCell: FormInputCell {
        fatalError("Subclass should override")
    }

    open var baseValue: CustomStringConvertible? {
        set { fatalError("Subclass should override") }
        get { fatalError("Subclass should override") }
    }

    // Used to check type when updating object's value with key `-value-coding
    open func isValueMatchRowType(value: Any) -> Bool {
        fatalError("Subclass must override")
    }
}

