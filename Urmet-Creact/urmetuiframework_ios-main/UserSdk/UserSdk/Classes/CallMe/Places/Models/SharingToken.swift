//
//  SharingToken.swift
//  CallMeSdk
//
//  Created by Matteo Cioppa on 26/07/22.
//

import CoreImage
import Foundation

public struct SharingToken: Hashable {
    private let completeName: String
    private let token: String
    private let model: String

    init(completeName: String, token: String, model: String) {
        self.completeName = completeName
        self.token = token
        self.model = model
    }

    var asData: Data? {
        let qr = SharingQRCode(destination: 1, model: model, token: token, from: completeName, role: "user")
        let qrData = try? JSONEncoder().encode(qr)
        guard let qrData = qrData else { return nil }
        return qrData
    }

    public var asImage: CIImage? {
        guard let jsonData = asData else { return nil }

        let transformation10x = CGAffineTransform(scaleX: 10, y: 10)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(jsonData, forKey: "inputMessage")
        return qrFilter.outputImage?.transformed(by: transformation10x) ?? nil
    }
}
