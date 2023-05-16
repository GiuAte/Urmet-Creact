//
//  PopupDisplayer.swift
//  Urmet-Creact
//
//  Created by Giulio Aterno on 11/05/23.
//

import UIKit
import PlugUI

protocol PopupDisplayer {
    func showPopup(title: String,
                   message: String,
                   style: AlertViewController.Style,
                   configuration: PopupConfiguration?,
                   didTapCloseButton: (() -> Void)?)
}

extension PopupDisplayer where Self: UIViewController {
    func showPopup(title: String,
                   message: String,
                   style: AlertViewController.Style,
                   configuration: PopupConfiguration? = nil,
                   didTapCloseButton: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            self.addLoaderView(title: title,
                               message: message,
                               style: style,
                               configuration: configuration,
                               didTapCloseButton: didTapCloseButton)
        }
    }

    private func addLoaderView(title: String, message: String, style: AlertViewController.Style, configuration: PopupConfiguration?, didTapCloseButton: (() -> Void)?) {
        let alert = AlertViewController(title: title, message: message, style: style, configuration: configuration)
        alert.didTapClose = didTapCloseButton
        self.present(alert,animated: true)
    }
}
