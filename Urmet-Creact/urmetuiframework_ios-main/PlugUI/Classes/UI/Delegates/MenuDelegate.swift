//
//  MenuDelegate.swift
//  PlugUI
//
//  Created by Silvio Fosso on 21/11/22.
//

import Foundation
public protocol MenuDelegate: class {
    func dismiss()
    func profileTapped()
    func locationTapped()
    func settingsTapped()
    func infoTapped()
    func logoutTapped()
}
