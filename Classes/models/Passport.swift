//
//  Passport.swift
//  Pods
//
//  Created by PrashantDixit on 02/06/25.
//


import UIKit
import UdentifyNFC

/// An Encodable wrapper for the third-party `Passport` struct.
@available(iOS 13.0, *)
public struct EncodablePassport: Encodable {
    public var documentType: String?
    public var personalNumber: String?
    public var documentNumber: String?
    public var documentCode: String?
    public var documentExpiryDate: String?
    public var firstName: String?
    public var lastName: String?
    public var dateOfBirth: String?
    public var gender: String?
    public var state: String?
    public var nationality: String?
    public var address: String
    public var phoneNumber: String
    public var birthPlace: String
    public var image: Data?
    public var userID: String

    /// - Parameter passport: The `UidentifyNFC.Passport` object to wrap.
    public init(passport: UdentifyNFC.Passport) {
        self.documentType = passport.documentType
        self.personalNumber = passport.personalNumber
        self.documentNumber = passport.documentNumber
        self.documentCode = passport.documentCode
        self.documentExpiryDate = passport.documentExpiryDate
        self.firstName = passport.firstName
        self.lastName = passport.lastName
        self.dateOfBirth = passport.dateOfBirth
        self.gender = passport.gender
        self.state = passport.state
        self.nationality = passport.nationality
        self.address = passport.address
        self.phoneNumber = passport.phoneNumber
        self.birthPlace = passport.birthPlace
        self.userID = passport.userID

        if let uiImage = passport.image {
            self.image = UIImagePNGRepresentation(uiImage)
        } else {
            self.image = nil
        }
    }
}
