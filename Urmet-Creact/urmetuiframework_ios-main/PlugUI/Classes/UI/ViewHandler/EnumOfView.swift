//
//  EnumOfView.swift
//  PlugUI
//
//  Created by Silvio Fosso on 14/11/22.
//

import Foundation
public enum Viewer {
    case GDPRView

//    func get() -> UIViewController {
//        switch self{
//        case .GDPRView:
//            return RegistrationThirdStepView()
//        }
//    }

    /* func get(controller : UIViewController = UIViewController(),ModalLocations items : [Location] = [Location](), ModalIndexSelected index : Int = 0, alertTitle title : String = "", alertMessage message : String = "", alertStyle style : AlertViewController.Style = .default, AcknowledgmentMessage messageAck : String) -> UIViewController {
             switch self {
             case .LoaderView:
                 return LoaderViewController()
             case .MenuView:
                 return MenuViewController(viewController: controller )
             case .ModalLocationController:
                 return ModalLocationViewController(items: items , selectedIndex: index)
             case .AlertController:
                 return AlertViewController(title: title, message: message,style: style)
             case .Acknowledgment:
                 return AcknowledgmentViewController(text: messageAck)

             //case .ConfigurationView:
             //    return ConfigurationModalViewController()
           //  case .WifiView:
              //   return ConfigurationWiFiViewController()
             //case .ConfigurationStep:
                 //return ConfigurationConnectivityStepView()
             }

         }

     func get() -> UIViewController{
         return LoaderViewController()
     }
     func get(controller : UIViewController) -> UIViewController{
         return MenuViewController(viewController: controller)
     }*/
}
