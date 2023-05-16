//
//  SipManager.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 21/11/22.
//

import Foundation

class SipManager: ISipManager {
    private let sipCallActionPerformer: ISipCallActionPerformer
    private let callStateChangedReceiver: ISipCallStateChangedReceiver
    private let ipercomCallDeviceSipService: IIpercomCallDeviceSipService
    private var callback: (SipMessage) -> Void = { _ in }

    init(sipCallActionPerformer: ISipCallActionPerformer,
         callStateChangedReceiver: ISipCallStateChangedReceiver,
         ipercomCallDeviceSipService: IIpercomCallDeviceSipService)
    {
        self.sipCallActionPerformer = sipCallActionPerformer
        self.callStateChangedReceiver = callStateChangedReceiver
        self.ipercomCallDeviceSipService = ipercomCallDeviceSipService
    }

    func addSipMessageReceiver(callback: @escaping Callback) {
        self.callback = callback
        callStateChangedReceiver.addCallStateChangedCallback(callback: callback)
    }

    func executeSipAction(sipAction: SipAction) {
        switch sipAction.sipActionType {
        case .CALL_DEVICE_REQ:
            manageCallDeviceReq(action: sipAction)
        case .CANCEL_CALL_REQ:
            manageCancelCallReq(action: sipAction)
        case .TOO_MANY_CALLS, .DECLINE_CALL_BUSY:
            manageDecline(action: sipAction, reason: .Busy)
        case .ANSWER:
            manageAnswer(action: sipAction)
        case .TERMINATE_CALL:
            manageTerminateCall(action: sipAction)
        case .ERROR:
            manageError(action: sipAction)
        case .SET_VIDEO_RECEIVER_VIEW:
            manageSetVideoReceiverView(action: sipAction)
        case .ACCEPT_EARLY_MEDIA:
            manageAcceptEarlyMedia(action: sipAction)
        case let .EXECUTE_IN_CALL_ACTION(toneAction: inCallToneAction):
            manageInCallToneAction(action: sipAction, inCallToneAction: inCallToneAction)
        case .TOGGLE_MUTE:
            manageToggleMute(action: sipAction)
        case .ROUTE_TO_SPEAKER:
            manageSetSpeakerOutput(action: sipAction)
        case .ROUTE_TO_EARPIECE:
            manageSetEarpieceOutput(action: sipAction)
        }
    }

    private func manageCallDeviceReq(action: SipAction) {
        guard let calleeInfo = action.calleeInfo else {
            Sdk.logger.error(message: "missing calleeInfo")
            return
        }

        ipercomCallDeviceSipService.call(device: calleeInfo.device,
                                         ofPlace: calleeInfo.place,
                                         callBackUri: action.uniqueUri,
                                         withDisplayName: "FIX_ME_REPLACE_ME",
                                         andReplyTo: action.uniqueUri) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.callback(SipMessage(eventType: .CALL_DEVICE_RES_SUCCESS, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
            case let .failure(err as IpercomCallDeviceSipService.ResultCodeError):
                switch err {
                case .busy:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_BUSY, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                case .unreachable:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_UNREACHABLE, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                case .unknownTopologicalCode:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_UNKNOWN_TOPOLOGICAL, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                case .deviceNotFound:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_DEVICE_NOT_FOUND, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                case .callTimedOut:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_TIMED_OUT, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                case .callRefused:
                    self.callback(SipMessage(eventType: .CALL_DEVICE_RES_REFUSED, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                default:
                    self.callback(SipMessage(eventType: .MESSAGE_ERROR, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
                }
            case .failure:
                self.callback(SipMessage(eventType: .MESSAGE_ERROR, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
            }
        }
    }

    private func manageCancelCallReq(action: SipAction) {
        guard let calleeInfo = action.calleeInfo else {
            Sdk.logger.error(message: "missing calleeInfo")
            return
        }

        ipercomCallDeviceSipService.cancelCall(device: calleeInfo.device,
                                               ofPlace: calleeInfo.place,
                                               callBackUri: action.uniqueUri,
                                               withDisplayName: "FIX_ME_REPLACE_ME",
                                               andReplyTo: action.uniqueUri) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.callback(SipMessage(eventType: .CANCEL_CALL_RES_SUCCESS, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
            case .failure:
                self.callback(SipMessage(eventType: .MESSAGE_ERROR, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
            }
        }
    }

    private func manageDecline(action: SipAction, reason: DeclineReason) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        sipCallActionPerformer.decline(remoteUri: remoteUri, reason: reason)
    }

    private func manageAnswer(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        sipCallActionPerformer.accept(remoteUri: remoteUri)
    }

    private func manageTerminateCall(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        sipCallActionPerformer.terminate(remoteUri: remoteUri)
    }

    private func manageSetVideoReceiverView(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri,
              let view = action.videoReceiverView
        else {
            Sdk.logger.error(message: "missing remoteUri or videoReceiverView")
            return
        }

        sipCallActionPerformer.setVideoReceiverView(view, remoteUri: remoteUri)
    }

    private func manageAcceptEarlyMedia(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        sipCallActionPerformer.acceptEarlyMedia(remoteUri: remoteUri)
    }

    private func manageInCallToneAction(action: SipAction, inCallToneAction: InCallToneAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        sipCallActionPerformer.sendDtmfs(inCallToneAction.rawValue, remoteUri: remoteUri)
    }

    private func manageToggleMute(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        if let isMuted = sipCallActionPerformer.toggleMute(remoteUri: remoteUri) {
            let eventType: CMEventType = isMuted ? .SIP_MICROPHONE_MUTED : .SIP_MICROPHONE_UNMUTED
            callback(SipMessage(eventType: eventType, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
        }
    }

    private func manageSetSpeakerOutput(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        let speakerSet = sipCallActionPerformer.setSpeakerOutput(remoteUri: remoteUri)

        if speakerSet {
            let eventType: CMEventType = .SIP_SPEAKER_OUTPUT
            callback(SipMessage(eventType: eventType, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
        }
    }

    private func manageSetEarpieceOutput(action: SipAction) {
        guard let remoteUri = action.callIdentifier.remoteUri else {
            Sdk.logger.error(message: "missing remoteUri")
            return
        }

        let earpieceSet = sipCallActionPerformer.setEarpieceOutput(remoteUri: remoteUri)
        if earpieceSet {
            let eventType: CMEventType = .SIP_EARPIECE_OUTPUT
            callback(SipMessage(eventType: eventType, callIdentifier: action.callIdentifier, localUri: action.uniqueUri))
        }
    }

    private func manageError(action _: SipAction) {
        // TODO: decide what is the best solution for a unhandled event
    }
}
