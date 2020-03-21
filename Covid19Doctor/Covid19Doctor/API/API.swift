//
//  API.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

struct Empty: Codable {}

protocol API {
    
    /// Verify if phone number is trusted and, if yes, send the verification code to the phone
    /// - Parameter number: the phone number
    func sendPhoneVerificationCode(_ number: String) -> Single<SendPhoneVerificationCodeResponse>
    
    /// Verify the code received via SMS
    /// - Parameters:
    ///   - code: the code received via SMS
    ///   - token: the jwt returned by sendPhoneVerificationCode
    func verifyPhoneCode(_ code: String, token: String) -> Single<VerifyPhoneCodeResponse>
    
    /// Get patient data from server
    /// - Parameter id: the patient's id
    func getPatient(id: String) -> Single<Patient>
    
    /// Change patient's covid19 status
    /// - Parameter patientId: the id of the patient
    /// - Parameter status: the status to set
    func setPatientStatus(patientId: String, status: PatientStatus) -> Single<Empty>
    
    /// Invite a doctor to the app via phone number
    /// - Parameter number: the phone number 
    func inviteDoctor(number: String) -> Single<Empty>
}
