//
//  ViewHandler.swift
//  PlugUI
//
//  Created by Silvio Fosso on 14/11/22.
//

import Foundation
import UserSdk

public class UIHandler {
    public static func overrideStart(view: inout UIWindow?, delegate: LoginDelegate) {
        let mainView = UIStoryboard(name: "Main", bundle: Bundle(for: UIHandler.self))
        guard let firstScene = FirstViewSceneManager.getUIWindowName() else { return }
        let viewcontroller = mainView.instantiateViewController(withIdentifier: firstScene) as UIViewController
        PlugUIContext.loginDelegate = delegate //TODO: refactor
        FontRegister.initFont()
        //ApiCall.shared.doGDPR()
        view?.rootViewController = viewcontroller
    }
}
