//
//  AlarmDelegate.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 10/10/22.
//

import Foundation

protocol AlarmDelegate {
    func didReceive(newAlarms alarms: [Alarm], for place: Place)
}
