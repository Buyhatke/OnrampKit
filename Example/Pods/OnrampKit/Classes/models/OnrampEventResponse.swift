//
//  OnrampEventResponse.swift
//  OnrampKit
//
//  Created by PrashantDixit on 18/08/23.
//

import Foundation

public struct OnrampEventResponse: Codable {
    public let type: String
    public let data: EventData
    public let isOnramp: Bool
}

public struct EventData: Codable {
    public let msg: String?
    public let fiatAmount: Double?
    public let cryptoAmount: Double?
    public let coinRate: Double?
    public let paymentMethod: String?
}

