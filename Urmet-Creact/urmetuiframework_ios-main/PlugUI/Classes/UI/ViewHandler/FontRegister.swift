//
//  FontRegister.swift
//  PlugUI
//
//  Created by Silvio Fosso on 15/11/22.
//

import Foundation

public class FontRegister {
    static let bundle = Bundle(for: FontRegister.self)

    public static func initFont() {
        let fileManager = FileManager.default

        do {
            let namesOfFont = try fileManager.contentsOfDirectory(atPath: bundle.bundlePath + "/UI/Fonts")
            namesOfFont.forEach { fontName in
                UIFont.jbs_registerFont(withFilenameString: fontName, bundle: bundle)
            }
        } catch {
            print(error)
        }
    }
}

public extension UIFont {
    static func jbs_registerFont(withFilenameString filenameString: String, bundle: Bundle) {
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &errorRef) == false {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
