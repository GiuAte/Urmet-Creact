//
//  IpercomGetGatewayService.swift
//  CallMeSdk
//
//  Created by RaffaeleApetino on 15/12/22.
//

import Foundation

class IpercomGetGatewayService: IIpercomGetGatewayService {
    private let uniqueSipAccountService: IUniqueSipAccountService
    private let ipercomGetGatewaySipService: IIpercomGetGatewaySipService

    init(uniqueSipAccountService: IUniqueSipAccountService, ipercomGetGatewaySipService: IIpercomGetGatewaySipService) {
        self.uniqueSipAccountService = uniqueSipAccountService
        self.ipercomGetGatewaySipService = ipercomGetGatewaySipService
    }

    func getGateway(for place: Place, completion: @escaping Completion) {
        uniqueSipAccountService.get { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(uniqueAccount):
                self.ipercomGetGatewaySipService.getGateway(for: place, andReplyTo: uniqueAccount.getUri()) { [weak self] result in
                    guard let self else { return }

                    switch result {
                    case let .success(gateway):
                        completion(.success(gateway))

                    case let .failure(error):
                        completion(.failure(self.map(error)))
                    }
                }
            case .failure:
                completion(.failure(IpercomGetGatewayServiceError.uniqueAccountNotFound))
            }
        }
    }

    private func map(_ error: IIpercomGetGatewaySipServiceError) -> IpercomGetGatewayServiceError {
        switch error {
        case .clientError:
            return .clientError
        case .invalidData:
            return .invalidData
        case .invalidPlace:
            return .invalidPlace
        }
    }
}
