//
//  Errors.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 14/2/2565 BE.
//

import Foundation

enum APIError: String, Error {
    case unsupportedCode = "unsupported-code"
    case malformedRequest = "malformed-request"
    case invalidKey = "invalid-key"
    case inactiveAccount = "inactive-account"
    case quotaReached = "quota-reached"
    case invalidJSON
    case unknownError
    case networkError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unsupportedCode:
            return NSLocalizedString(
                "Currency code is not supported",
                comment: ""
            )
        case .malformedRequest:
            return NSLocalizedString(
                "Invalid request format",
                comment: ""
            )
        case .invalidKey:
            return NSLocalizedString(
                "Invalid API key",
                comment: ""
            )
        case .inactiveAccount:
            return NSLocalizedString(
                "Email address is not confirmed",
                comment: ""
            )
        case .quotaReached:
            return NSLocalizedString(
                "API quota limit has been reached",
                comment: ""
            )
        case .invalidJSON:
            return NSLocalizedString(
                "JSON data is invalid",
                comment: ""
            )
        case .networkError:
            return NSLocalizedString(
                "Network error",
                comment: ""
            )
        case .unknownError:
            return NSLocalizedString(
                "Unknows error",
                comment: ""
            )
        }
    }
}
