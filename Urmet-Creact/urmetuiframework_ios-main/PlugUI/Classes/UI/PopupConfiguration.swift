//
//  PopupConfiguration.swift
//  Crono
//
//  Created by Silvio Fosso on 15/03/23.
//

import UIKit
public enum PopupConfiguration{
    case doubleButton(titleSuccessButton: String, titleCancelButton: String, onSuccess:() -> (), onCancel: () -> ())
}
