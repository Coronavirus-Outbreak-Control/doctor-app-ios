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
    
    func verifyPhoneCode(_ code: String, number: String) -> Single<VerifyPhoneCodeResponse> {
        let req = VerifyPhoneCodeRequest(code: code)
        return client.send(apiRequest: req)
    }
    
    func setPatientStatus(patientId: String, status: Covid19Status) -> Single<Empty> {
        fatalError("not implemented")
    }
    
    func sendInvitation(toNumber number: String) -> Single<Empty> {
        fatalError("not implemented")
    }
}
