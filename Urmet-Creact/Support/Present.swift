//
//  Present.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//


import Foundation
import UIKit

class Present {
  static func withModal(navigationController: UINavigationController,
             modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
             animated: Bool = true,
             completion: (() -> Void)? = nil) {
    if let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController {
      navigationController.modalPresentationStyle = modalPresentationStyle
      rootVC.present(navigationController, animated: animated, completion: completion)
    }
  }
  static func menu(controller: UIViewController, completion: (() -> Void)? = nil) {
    if let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController {
      presentFromController(rootVC, controllerToShow: controller, modalPresentationStyle: .custom, animated: true, completion: completion)
    }
  }
  static func wherever(controller: UIViewController, modalPresentationStyle: UIModalPresentationStyle? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
    if let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController {
      presentFromController(rootVC, controllerToShow: controller, modalPresentationStyle: modalPresentationStyle, animated: animated, completion: completion)
    }
  }
  static private func presentFromController(_ controller: UIViewController,
                       controllerToShow: UIViewController,
                       modalPresentationStyle: UIModalPresentationStyle? = nil,
                       animated: Bool,
                       completion: (() -> Void)?) {
    if let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController {
      presentFromController(visibleVC,
                 controllerToShow: controllerToShow,
                 modalPresentationStyle: modalPresentationStyle,
                 animated: animated,
                 completion: completion)
    } else if let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController {
      presentFromController(selectedVC,
                 controllerToShow: controllerToShow,
                 modalPresentationStyle: modalPresentationStyle,
                 animated: animated,
                 completion: completion)
    } else {
      if let modalPresentationStyle {
        controllerToShow.modalPresentationStyle = modalPresentationStyle
      }
      controller.present(controllerToShow, animated: animated, completion: completion)
    }
  }
}
