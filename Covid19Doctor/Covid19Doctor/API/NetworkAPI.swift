//
//  NetworkAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

// TODO
class NetworkAPI: API {
    
    func sendPhoneVerificationCode(_ number: String) -> Single<Void> {
        fatalError("not implemented")
    }
    
    func verifyPhoneCode(_ code: String, number: String) -> Single<Void> {
        fatalError("not implemented")
    }
    
    func setPatientStatus(patientId: String, status: Covid19Status) -> Single<Void> {
        fatalError()
    }
}
