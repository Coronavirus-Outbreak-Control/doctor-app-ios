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
    func sendPhoneVerificationCode(_ number: String) -> Single<Empty>
    
    /// Verify the code received via SMS
    /// - Parameters:
    ///   - code: the code received via SMS
    func verifyPhoneCode(_ code: String) -> Single<VerifyPhoneCodeResponse>
    
    /// Get the jwt used to make all authenticated requests
    /// - Parameter reAuthToken: the token returned from the verification
    func authenticate(reAuthToken: String) -> Single<AuthenticateResponse>
    
    /// Get patient data from server
    /// - Parameter id: the patient's id
    func getPatient(id: String) -> Single<Patient>
    
    /// Change patient's status
    /// - Parameter patientId: the id of the patient
    /// - Parameter status: the status to set
    func setPatientStatus(patientId: String, status: PatientStatus,
                          ignoreStatusCheck: Bool) -> Single<Empty>
    
    /// Invite a doctor to the app via phone number
    /// - Parameter number: the phone number 
    func inviteDoctor(number: String) -> Single<Empty>
    
    /// Get list of pending patient id
    /// - Parameter doctorId: the doctor the patients belong to
    func getSuspects(doctorId: String) -> Single<GetSuspectsResponse>
    
    
    func runAuthenticated<T>(reAuthToken: String, apiBuilder: @escaping () -> Single<T>) -> Single<T>
}
