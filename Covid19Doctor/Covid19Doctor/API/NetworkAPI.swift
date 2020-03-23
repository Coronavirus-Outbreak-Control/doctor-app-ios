//
//  NetworkAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

class NetworkAPI: API {
    
    let client = NetworkClient(baseURL: URL(string: "http://doctors.api.coronaviruscheck.org/v1/")!)
    
    func sendPhoneVerificationCode(_ number: String) -> Single<Empty> {
        let req = SendPhoneVerificationCodeRequest(phoneNumber: number)
        return client.send(apiRequest: req)
    }
    
    func verifyPhoneCode(_ code: String) -> Single<VerifyPhoneCodeResponse> {
        let req = VerifyPhoneCodeRequest(code: code)
        return client.send(apiRequest: req)
    }
    
    func authenticate(reAuthToken: String) -> Single<AuthenticateResponse> {
        let req = AuthenticateRequest(reAuthToken: reAuthToken)
        return client.send(apiRequest: req)
    }
    
    func getPatient(id: String) -> Single<Patient> {
        fatalError("not implemented")
    }
    
    func setPatientStatus(patientId: String, status: PatientStatus) -> Single<Empty> {
        guard let jwt: String = Database.shared.getAccountValue(key: .jwt) else {
            return .error(Errors.userNotLoggedIn)
        }
        let req = SetPatientStatusRequest(authToken: jwt, patientId: patientId, newStatus: status)
        return client.send(apiRequest: req)
    }
    
    func inviteDoctor(number: String) -> Single<Empty> {
        guard let jwt: String = Database.shared.getAccountValue(key: .jwt) else {
            return .error(Errors.userNotLoggedIn)
        }
        let req = InviteDoctorRequest(authToken: jwt, phoneNumber: number)
        return client.send(apiRequest: req)
    }
}
