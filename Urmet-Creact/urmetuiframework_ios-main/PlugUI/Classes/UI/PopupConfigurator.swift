//
//  PopupConfiguration.swift
//  Crono
//
//  Created by Silvio Fosso on 15/03/23.
//


import UIKit

class PopupConfigurator {
    
    static func components(by configuration: PopupConfiguration) -> [UIButton] {
        switch configuration{
        case .doubleButton(let textFirstButton, let textSecondButton, let success, let cancel):
            let button = PrimaryButton()
            button.setAttributedTitle(textFirstButton.toStyle(.Body1Regular, color: .black), for: .normal)
            button.cornerRadius = button.frame.height / 2
            button.backgroundColor = .red
                
            let secondButton = SecondaryButton()
            secondButton.setAttributedTitle(textSecondButton.toStyle(.Body1Regular, color: .white), for: .normal)
            secondButton.cornerRadius = button.frame.height / 2

            PopupConfigurator.setHandler(button: button, escaping: success)
            PopupConfigurator.setHandler(button: secondButton, escaping: cancel)
            return [secondButton, button]
        }
    }
    
    static func setHandler(button: UIButton, escaping: @escaping() -> ()){
        button.addAction {
            escaping()
        }
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
