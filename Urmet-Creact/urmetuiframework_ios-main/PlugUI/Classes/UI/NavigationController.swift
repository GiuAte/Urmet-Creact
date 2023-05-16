//
//  NavigationController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 07/11/22.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.isEnabled = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        interactivePopGestureRecognizer?.delegate = self
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        interactivePopGestureRecognizer?.delegate = self

        return super.popViewController(animated: animated)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer || viewControllers.count < 2 {
            return false
        }
        return true
    }
}
