//
//  HttpHandler.swift
//  PlugUI
//
//  Created by Silvio Fosso on 18/01/23.
//

import Foundation
import UIKit

// Classe Http Base
public class Http {
    internal let baseURL = URL(string: "https://ucloud-dev.urmet.com")!

    internal var session = URLSession(configuration: .ephemeral)

    internal var httpClient: URLSessionHTTPClient

    internal var appGroupId = "group.com.urmet.CallMeSampleApp"

    internal var teamId = "H7TERFXEST"

    internal var bundleIdentifier = "com.urmet.CallMeSampleApp"

    internal var realm = "sip-dev.urmet.com"

    internal var origin = "CALLME"

    init() {
        httpClient = URLSessionHTTPClient(session: session)
    }
}
