//
//  Errors.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

enum Errors: Error {
    case unknown
    case phoneNotTrusted
    case invalidPatientId
    case userNotActivated       // missing reAuthToken
    case userNotAuthenticated   // missing jwt
    case invalidPhoneNumber
    case verificationCodeExpired
    case tokenAlreadyRequested
    case requestFailed(Int)
}
