//
//  GDPRMap.swift
//  PlugUI
//
//  Created by Silvio Fosso on 20/01/23.
//

import Foundation
class GDPRMap {
    static func map(_ data: Data, and response: HTTPURLResponse) -> GDPRService.Result {
        guard
            response.statusCode == 200,
            let statements = try? JSONDecoder().decode([GDPRStatement].self, from: data)
        else {
            return .failure(NSError(domain: response.debugDescription, code: response.statusCode))
        }
        return .success(statements)
    }
}
