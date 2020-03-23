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
                let response = VerifyPhoneCodeResponse(id: 1, reAuthToken: "re12345")
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
    
    func authenticate(reAuthToken: String) -> Single<AuthenticateResponse> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                let response = AuthenticateResponse(jwt: "jwt123")
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
    
    func getPatient(id: String) -> Single<Patient> {
        .create { observer in
            DispatchQueue.main.delay(1) {
                let patient = Patient(id: "1", status: .normal)
                observer(.success(patient))
            }
            return Disposables.create()
        }
    }
    
    func setPatientStatus(patientId: String, status: PatientStatus) -> Single<Empty> {
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
                Database.shared.setAccountValue(res.jwt, key: .jwt)
                return apiBuilder()
            }
    }
}
