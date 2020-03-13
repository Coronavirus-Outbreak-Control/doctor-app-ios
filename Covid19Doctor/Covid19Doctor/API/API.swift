//
//  API.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

protocol API {
    
    /// Verify if phone number is trusted and, if yes, send the verification code to the phone
    /// - Parameter number: the phone number
    func sendPhoneVerificationCode(_ number: String) -> Single<Void>
    
    /// Verify the code received via SMS
    /// - Parameters:
    ///   - code: the code received via SMS
    ///   - number: the phone number
    func verifyPhoneCode(_ code: String, number: String) -> Single<Void>
    
    /// Change patient's covid19 status
    /// - Parameter patientId: the id of the patient
    /// - Parameter status: the status to set
    func setPatientStatus(patientId: String, status: Covid19Status) -> Single<Void>
}
