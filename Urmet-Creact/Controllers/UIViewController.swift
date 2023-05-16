//
//  UiViewController.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//

import Foundation
import UIKit

extension UIViewController {
  var wrappedInNavigationController: UINavigationController {
    if let nc = self as? UINavigationController {
      return nc
    } else {
      return UINavigationController(rootViewController: self)
    }
  }
  func topMostViewController() -> UIViewController {
    if let presented = presentedViewController {
      return presented.topMostViewController()
    }
    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController() ?? navigation
    }
    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController() ?? tab
    }
    return self
  }
}
