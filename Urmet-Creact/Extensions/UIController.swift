//
//  UIController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//

import Foundation
import UIKit

extension UIApplication {
  open var firstKeyWindow: UIWindow? {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
      if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
        window = keyWindow
      }
    } else {
      window = keyWindow
    }
    return window
  }
  func topMostViewController() -> UIViewController? {
    firstKeyWindow?.rootViewController?.topMostViewController()
  }
}
