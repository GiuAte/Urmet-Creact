//
//  TypedRow.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 08/06/23.
//

import Foundation
import UIKit

// Provide concrete type to make your own rows
public typealias FieldRow = TypedRow<String>
public typealias StringRow = TypedRow<String>
public typealias DoubleRow = TypedRow<Double>
public typealias IntRow = TypedRow<Int>
public typealias BoolRow = TypedRow<Bool>
public typealias DecimalRow = TypedRow<NSDecimalNumber> // Objective does not support Decimal type
public typealias DateRow = TypedRow<Date>

// A generic model for inputing a value
public class TypedRow<T>: BaseRow where T: CustomStringConvertible, T: Equatable {
    public override var baseValue: CustomStringConvertible? {
        get { return value }
        set { value = newValue as? T }
    }

    public override var baseCell: FormInputCell {
        return cell
    }

    var value: T?
    public let cell: TypedInputCell<T>

    public override var description: String {
        return value?.description ?? ""
    }

    open override func isValueMatchRowType(value: Any) -> Bool {
        let t = type(of: value)
        return T.self == t
    }

    public required init(title: String,
                         icon: String? = nil,
                         kvcKey: String? = nil,
                         value: T?,
                         placeholder: String? = nil,
                         validator: Validator? = nil
    ) {
        self.cell = TypedInputCell()
        super.init()
        self.title = title
        self.icon = icon
        self.value = value
        self.kvcKey = kvcKey
        self.placeholder = placeholder
        self.validator = validator
    }
    
    convenience init(title: String,
                     icon: String? = nil,
                     kvcKey: String? = nil,
                     value: T? = nil,
                     choosingList: [Any]? = nil,
                     placeholder: String? = nil,
                     regexValidator: String? = nil,
                     validationFailedMessage: String? = nil,
                     fieldType: any RawRepresentable,
                     fieldEnabled: Bool = true,
                     cellType: CellType = .field) {
        self.init(title: title,
                  icon: icon,
                  kvcKey: kvcKey,
                  value: value,
                  placeholder: placeholder,
                  validator: nil)
        self.validationFailedMessage = validationFailedMessage
        self.regexValidator = regexValidator
        self.fieldType = fieldType
        self.cellType = cellType
        self.choosingList = choosingList
        self.fieldEnabled = fieldEnabled
    }
}

