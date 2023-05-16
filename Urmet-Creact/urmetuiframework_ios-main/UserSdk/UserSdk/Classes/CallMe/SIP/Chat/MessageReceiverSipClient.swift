//
//  MessageReceiverSipClient.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 15/09/22.
//

import Foundation

protocol MessageReceiverSipClient: AnyObject {
    var delegate: SendReceiveMessageSipClient? { get set }
    func didReceive(message: Data)
}
