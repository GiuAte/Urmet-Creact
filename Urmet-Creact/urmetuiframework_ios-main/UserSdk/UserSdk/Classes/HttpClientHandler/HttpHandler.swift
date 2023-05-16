//
//  HttpHandler.swift
//  PlugUI
//
//  Created by Silvio Fosso on 20/01/23.
//

import Foundation
import UIKit
class HttpHandler: Http {
    static var shared = HttpHandler()

    private var sdk: Sdk?

    override init() {
        super.init()

        sdk = Sdk(baseURL: super.baseURL,
                  client: super.httpClient,
                  appGroupId: super.appGroupId,
                  teamId: super.teamId,
                  bundleIdentifier: super.bundleIdentifier)
    }

    func getSdk() -> Sdk? {
        return sdk
    }

    func resetHTTPClientSession() {
        super.session.reset {}
    }
}
