//
//  ConfigurationHandler.swift
//  PlugUI
//
//  Created by Silvio Fosso on 18/11/22.
//

import Foundation
public class ConfigurationHandler {
    public static var shared = ConfigurationHandler()
    private var dictionary = NSDictionary()

    init() {
        dictionary = NSDictionary(contentsOfFile: Bundle(for: ConfigurationHandler.self).path(forResource: "Configuration", ofType: "plist") ?? "") ?? NSDictionary()
    }
}
