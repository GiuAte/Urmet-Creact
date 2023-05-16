//
//  OldCfwAlarmsDelegate.swift
//  CallMeSdk
//
//  Created by Massimiliano Bonafede on 10/10/22.
//

import Foundation

final class OldCfwAlarmsDelegate {
    private let places: [Place]
    private let delegate: AlarmDelegate

    init(places: [Place], delegate: AlarmDelegate) {
        self.places = places
        self.delegate = delegate
    }

    enum Error: Swift.Error {
        case invalidData
    }

    func didReceive(message: Data) {
        guard let result = map(message) else { return }
        delegate.didReceive(newAlarms: result.alarm, for: result.place)
    }
}

extension OldCfwAlarmsDelegate {
    func map(_ message: Data) -> (alarm: [Alarm], place: Place)? {
        let macIndex = 1
        let senderIndex = 2

        guard let message = String(data: message, encoding: .utf8) else { return nil }

        let array = message.components(separatedBy: "\n")

        guard array.count >= 3 else { return nil }

        let mac = array.get(at: macIndex)
        let sender = array.get(at: senderIndex)
        var alarms: [String] = []

        guard array.count >= 4 else {
            if let place = places.first(where: { $0.mac == mac }) {
                return ([], place)
            } else {
                return nil
            }
        }

        for alarmIndex in 3 ... array.count - 1 {
            alarms.append(array.get(at: alarmIndex))
        }

        if let place = places.first(where: { $0.mac == mac }) {
            let alarms = alarms.map { Alarm(sender: sender,
                                            state: .Unknown,
                                            ts: convertToUNIXTime($0),
                                            type: .Unknown,
                                            ipercomAttributes: nil,
                                            cfwAttributes: CfwAlarmAttributes(mac: mac)) }
            return (alarms, place)
        } else {
            return nil
        }
    }

    private func convertToUNIXTime(_ date: String) -> UInt64 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = dateFormatter.date(from: date)
        let timeInterval = date!.timeIntervalSince1970
        return UInt64(timeInterval)
    }

    private func getStringFrom(index: Int, of array: [String]) -> String {
        return array[index]
    }
}

private extension Array where Element == String {
    func get(at index: Int) -> String {
        guard index < count else { return "" }
        return self[index]
    }
}
