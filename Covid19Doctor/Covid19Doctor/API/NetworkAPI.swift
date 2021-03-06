//
//  NetworkAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

class NetworkAPI: API {
    
    // remote
    let client = NetworkClient(baseURL: URL(string: "https://doctors.coronaviruscheck.org/v1")!)
    // local
//    let client = NetworkClient(baseURL: URL(string: "http://192.168.1.172:9000/v1")!)
    
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
    
    func setPatientStatus(patientId: String, status: PatientStatus,
                          ignoreStatusCheck: Bool = false) -> Single<Empty> {
        guard let jwt: String = Database.shared.getAccountValue(key: .jwt) else {
            return .error(Errors.userNotAuthenticated)
        }
        let req = SetPatientStatusRequest(authToken: jwt, patientId: patientId, newStatus: status,
                                          ignoreStatusCheck: ignoreStatusCheck)
        return client.send(apiRequest: req)
    }
    
    func inviteDoctor(number: String) -> Single<Empty> {
        guard let jwt: String = Database.shared.getAccountValue(key: .jwt) else {
            return .error(Errors.userNotAuthenticated)
        }
        let req = InviteDoctorRequest(authToken: jwt, phoneNumber: number)
        return client.send(apiRequest: req)
    }
    
    func getSuspects(doctorId: String) -> Single<GetSuspectsResponse> {
        guard let jwt: String = Database.shared.getAccountValue(key: .jwt) else {
            return .error(Errors.userNotAuthenticated)
        }
        let req = GetSuspectsRequest(authToken: jwt, doctorId: doctorId)
        return client.send(apiRequest: req)
    }
}

extension NetworkAPI {
    func runAuthenticated<T>(reAuthToken: String, apiBuilder: @escaping () -> Single<T>) -> Single<T> {
        authenticate(reAuthToken: reAuthToken)
            .flatMap { res in
                Database.shared.setAccountValue(res.token, key: .jwt)
                return apiBuilder()
            }
    }
}
