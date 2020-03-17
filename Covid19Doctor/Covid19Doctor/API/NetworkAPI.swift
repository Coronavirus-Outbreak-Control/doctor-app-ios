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
    
    func sendPhoneVerificationCode(_ number: String) -> Single<Void> {
//        let req = SendPhoneVerificationCodeRequest(phoneNumber: number)
//        return client.send(apiRequest: req)
        fatalError("not implemented")
    }
    
    func verifyPhoneCode(_ code: String, number: String) -> Single<Void> {
        fatalError("not implemented")
    }
    
    func setPatientStatus(patientId: String, status: Covid19Status) -> Single<Void> {
        fatalError("not implemented")
    }
    
    func sendInvitation(toNumber number: String) -> Single<Void> {
        fatalError("not implemented")
    }
    
    
    class SendPhoneVerificationCodeRequest: NetworkRequest {
        let method = RequestType.GET
        let path = "/activation/request"
        let parameters = [String : String]()
        let body: Data?
        
        init(phoneNumber: String) {
            let dict = ["phone_number" : phoneNumber]
            self.body = try! JSONSerialization.data(withJSONObject: dict)
        }
    }
}
