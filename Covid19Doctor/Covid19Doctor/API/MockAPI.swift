//
//  MockAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

class MockAPI: API {
    
    func sendPhoneVerificationCode(_ number: String) -> Single<Empty> {
        // ok if italian number
        .create { observer in
            DispatchQueue.main.delay(1) {
                if !(number.hasPrefix("+39") || number.hasPrefix("0039")) {
                    observer(.error(Errors.phoneNotTrusted))
                } else {
                    observer(.success(Empty()))
                }
            }
            return Disposables.create()
        }
    }
    
    func verifyPhoneCode(_ code: String) -> Single<VerifyPhoneCodeResponse> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                let response = VerifyPhoneCodeResponse(id: 1, token: "re12345")
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
    
    func authenticate(reAuthToken: String) -> Single<AuthenticateResponse> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                let response = AuthenticateResponse(token: "jwt123")
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
    
    func getPatient(id: String) -> Single<Patient> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                let patient = Patient(id: "1", status: .negative)
                observer(.success(patient))
            }
            return Disposables.create()
        }
    }
    
    func setPatientStatus(patientId: String, status: PatientStatus,
                          ignoreStatusCheck: Bool = false) -> Single<Empty> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                observer(.success(Empty()))
            }
            return Disposables.create()
        }
    }
    
    func inviteDoctor(number: String) -> Single<Empty> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                observer(.success(Empty()))
            }
            return Disposables.create()
        }
    }
    
    
    func runAuthenticated<T>(reAuthToken: String, apiBuilder: @escaping () -> Single<T>) -> Single<T> {
        authenticate(reAuthToken: reAuthToken)
            .flatMap { res in
                Database.shared.setAccountValue(res.token, key: .jwt)
                return apiBuilder()
            }
    }
}
