//
//  Sdk.swift
//  CallMeSdk
//
//  Created by Stefano Martinallo on 30/08/22.
//

import Foundation
import Network

/// This is class configures the CallMe SDK.
///
/// You can create several instances of the SDK, each one with a specific configuration but to keep things
/// simple you should create one instance of the SDK and keep a strong reference to it (say in the AppDelegate).
///
/// ```
/// class AppDelegate {
///     private let sdk = Sdk()
/// }
/// ``
public final class Sdk {
    private let baseURL: URL
    private let client: HTTPClient
    private let origin: String
    private let teamId: String
    private let bundleIdentifier: String
//    private let coreManager: LinphoneCoreManager
    private let maxSimoultaneouslyCalls: Int
    static let logger: SdkLogger = .init()

//    private lazy var accountRegistrationManager: AccountRegistrationManager = {
//        let accountStore = try! CoreDataAccountStore(storeURL: getStoreUrl())
//        let placeStore = try! CoreDataPlaceStore(storeURL: getStoreUrl())
//       // let registrationSipClient = LinphoneRegistrationSipClient(core: coreManager.getCore(), teamId: teamId, bundleIdentifier: bundleIdentifier)
//        let registrationManager = AccountRegistrationManager(
//            domain: realm,
//            accountStore: accountStore,
//            placeStore: placeStore,
//            registrationClient: registrationSipClient)
//
//        return registrationManager
//    }()

//    private lazy var idMatchingMessageSipClient: IdMatchingMessageSipClient = {
//        let messageSenderSipClient = LinphoneMessageSenderSipClient(core: coreManager.getCore())
//        let messageReceiverSipClient = LinphoneMessageReceiverSipClient(core: coreManager.getCore())
//        let idMatchingMessageSipClient = IdMatchingMessageSipClient(sender: messageSenderSipClient, receiver: messageReceiverSipClient)
//
//        return idMatchingMessageSipClient
//    }()

//    private lazy var uniqueSipAccountService: IUniqueSipAccountService = {
//        let accountStore = try! CoreDataAccountStore(storeURL: getStoreUrl())
//        let createSipAccountService = CreateSipAccountService(client: client, baseURL: baseURL)
//        let uniqueSipAccountService = UniqueSipAccountService(accountStore: accountStore, createSipAccountService: createSipAccountService, accountRegistrationManager: accountRegistrationManager)
//
//        return uniqueSipAccountService
//    }()

//    private lazy var callsServiceRetriever: CallsServiceRetriever = {
//        let sipCallActionPerformer = LinphoneSipCallActionPerformer(core: coreManager.getCore())
//        let callStatusReceiver = LinphoneCallStateChangedReceiver(core: coreManager.getCore())
//        let ipercomCallDeviceSipService = IpercomCallDeviceSipService(client: idMatchingMessageSipClient)
//        let sipManager = SipManager(sipCallActionPerformer: sipCallActionPerformer,
//                                    callStateChangedReceiver: callStatusReceiver,
//                                    ipercomCallDeviceSipService: ipercomCallDeviceSipService)
//
//        let callsServiceRetriever = CallsServiceRetriever(uniqueSipAccountService: uniqueSipAccountService, sipManager: sipManager, maxControllers: maxSimoultaneouslyCalls)
//
//        return callsServiceRetriever
//    }()

    /// - Parameters:
    ///     - baseURL: The server endpoint. This parameter can be used to hit a production or development environment.
    ///     - client: The client that handles all the HTTP requests. The SDK provides an `URLSessionHTTPClient` ready to use.
    ///     - appGroupId: The appGroup identifier for your app. The value must be line **group.<any-identifier>**.
    ///     - origin: This parameter identifies the app the uses the SDK. Default value is **CALLME**.
    ///     - realm: This parameter is the SIP domain. Default value is **sip.urmet.com**.
    ///     - maxSimoultaneouslyCalls: number of concurrently calls supported (at the same time). Default value is **1**.
    public init(baseURL: URL, client: HTTPClient, appGroupId _: String, teamId: String, bundleIdentifier: String, origin: String = "CALLME", maxSimoultaneouslyCalls: Int = 1) {
        self.baseURL = baseURL
        self.client = client
        self.origin = origin

//        coreManager = Sdk.makeCoreManager(appGroupId: appGroupId)
        self.teamId = teamId
        self.bundleIdentifier = bundleIdentifier
        self.maxSimoultaneouslyCalls = maxSimoultaneouslyCalls
        Sdk.logger.info(message: "---NEW SESSION---")
    }

    public func getAuthenticator() -> IAuthenticator {
        let authenticator = Authenticator(client: client, baseUrl: baseURL)
        return AuthenticatorWithUniqueGenerate(authenticatorService: authenticator)
    }

    public func getCloudAccountCreatorService() -> ICloudAccountCreatorService {
        let validator = Validator.self
        return CloudAccountCreatorService(client: client, baseUrl: baseURL, emailValidator: validator, passwordValidator: validator)
    }

    public func getGdprService() -> IGDPRService {
        return GDPRService(client: client, baseURL: baseURL, origin: origin)
    }

    public func getResetPasswordService() -> IResetPasswordService {
        return ResetPasswordService(baseURL: baseURL, client: client)
    }

    public func getUserChangePasswordService() -> IUserChangePasswordService {
        return UserChangePasswordService(validator: Validator.self, baseUrl: baseURL, client: client)
    }

    public func getUserProfileService() -> IUserProfileService {
        let accountStore = try! CoreDataAccountStore(storeURL: getStoreUrl())
        let userProfileService = UserProfileService(client: client, baseURL: baseURL, accountStore: accountStore, origin: origin)

        return UserProfileWithAccountsService(profileService: userProfileService)
    }

    public func getSetRelationNameService() -> ISetRelationNameService {
        return SetRelationNameService(baseUrl: baseURL, client: client)
    }

    public func getSharedUsersService() -> ISharedUsersService {
        let getSharedUsersService = GetSharedUsersService(client: client, baseUrl: baseURL)
        let deleteSharedUserService = DeleteSharedUserService(client: client, baseUrl: baseURL)
        let sharingTokenGeneratorService = SharingTokenGeneratorService(client: client, baseUrl: baseURL)
        return SharedUsersService(getSharedUsersService: getSharedUsersService, deleteSharedUserService: deleteSharedUserService, sharingTokenGeneratorService: sharingTokenGeneratorService)
    }

//    public func startCore(completion: @escaping () -> Void) {
//        coreManager.start { [self] _ in
//            accountRegistrationManager.sync {
//                completion()
//            }
//        }
//    }

//    public func stopCore() {
//        coreManager.stop { _ in }
//    }

//    public func getCallsService(completion: @escaping ICallsServiceRetriever.Completion) {
//        if let callsService {
//            completion(.success(callsService))
//        }
//
//        callsServiceRetriever.getCallsService { [weak self] result in
//            if case let .success(callsService) = result,
//               let self {
//                self.callsService = callsService
//            }
//
//            completion(result)
//        }
//    }

//    public func getMissedCallsService() -> IMissedCallsService {
//        let missedCallStore = try! CoreDataMissedCallsStore(storeURL: getStoreUrl())
//
//        let ipercomMissedCallsService = IpercomGetMissedCallsSipService(client: idMatchingMessageSipClient)
//        let services: [PlaceStrategy: IMissedCallsSipService] = [
//            .IpercomMissedCalls: ipercomMissedCallsService,
//        ]
//        let remoteLoader = RemoteMissedCallsLoader(missedCallsServices: services, uniqueSipAccountService: uniqueSipAccountService)
//        let saver = LocalMissedCallsSaver(store: missedCallStore)
//        let remoteLoaderWithSaver = MissedCallsLoaderWithSaver(loader: remoteLoader, saver: saver)
//
//        let localLoader = LocalMissedCallsLoader(store: missedCallStore)
//        return CompositeMissedCallsService(localLoader: localLoader, remoteLoader: remoteLoaderWithSaver)
//    }

//    public func getAlarmsService() -> IAlarmsService {
//        let alarmsStore = try! CoreDataAlarmsStore(storeURL: getStoreUrl())
//
//        let ipercomAlarmsService = IpercomGetAlarmsSipService(client: idMatchingMessageSipClient)
//        let services: [PlaceStrategy: IGetAlarmsSipService] = [
//            .IpercomAlarms: ipercomAlarmsService,
//        ]
//        let remoteLoader = RemoteAlarmsLoader(alarmsServices: services, uniqueSipAccountService: uniqueSipAccountService)
//        let saver = LocalAlarmsSaver(store: alarmsStore)
//        let remoteLoaderWithSaver = AlarmsLoaderWithSaver(loader: remoteLoader, saver: saver)
//
//        let localLoader = LocalAlarmsLoader(store: alarmsStore)
//        return CompositeAlarmsService(localLoader: localLoader, remoteLoader: remoteLoaderWithSaver)
//    }

//    public func getCamerasService() -> ICamerasService {
//        let devicesStore = try! CoreDataDevicesStore(storeURL: getStoreUrl())
//
//        let ipercomDevicesService = IpercomGetDevicesSipService(client: idMatchingMessageSipClient)
//        let services: [PlaceStrategy: IGetDevicesSipService] = [
//            .IpercomDevices: ipercomDevicesService,
//        ]
//        let remoteLoader = RemoteDevicesLoader(devicesServices: services, uniqueSipAccountService: uniqueSipAccountService)
//        let saver = LocalDevicesSaver(store: devicesStore)
//        let remoteLoaderWithSaver = DevicesLoaderWithSaver(loader: remoteLoader, saver: saver)
//
//        let localLoader = LocalCamerasLoader(store: devicesStore)
//        return CompositeCamerasService(localLoader: localLoader, remoteLoader: remoteLoaderWithSaver)
//    }
//
//    public func getContactsService() -> IContactsService {
//        let devicesStore = try! CoreDataDevicesStore(storeURL: getStoreUrl())
//
//        let ipercomDevicesService = IpercomGetDevicesSipService(client: idMatchingMessageSipClient)
//        let services: [PlaceStrategy: IGetDevicesSipService] = [
//            .IpercomDevices: ipercomDevicesService,
//        ]
//        let remoteLoader = RemoteDevicesLoader(devicesServices: services, uniqueSipAccountService: uniqueSipAccountService)
//        let saver = LocalDevicesSaver(store: devicesStore)
//        let remoteLoaderWithSaver = DevicesLoaderWithSaver(loader: remoteLoader, saver: saver)
//
//        let localLoader = LocalContactsLoader(store: devicesStore)
//        return CompositeContactsService(localLoader: localLoader, remoteLoader: remoteLoaderWithSaver)
//    }

    private func getStoreUrl() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("CallMeSdk.store")
    }

    public static func exportSDKLogs() -> Result<URL, LoggerError> {
        return Sdk.logger.exportOnFile(fileName: "SDK_CALLME_LOG")
    }
}
