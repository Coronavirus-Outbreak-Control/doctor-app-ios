//
//  MockAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

class MockAPI: API {
    
    func sendPhoneVerificationCode(_ number: String) -> Single<Void> {
        // ok if italian number
        return Single.create { observer in
            DispatchQueue.main.delay(1) {
                if !(number.hasPrefix("+39") || number.hasPrefix("0039")) {
                    observer(.error(Errors.phoneNotTrusted))
                } else {
                    observer(.success(Void()))
                }
            }
            return Disposables.create()
        }
    }
    
    func verifyPhoneCode(_ code: String, number: String) -> Single<Void> {
        return Single.create { observer in
            DispatchQueue.main.delay(1) {
                observer(.success(Void()))
            }
            return Disposables.create()
        }
    }
    
    func setPatientStatus(patientId: String, status: Covid19Status) -> Single<Void> {
        return Single.create { observer in
            DispatchQueue.main.delay(1) {
                observer(.success(Void()))
            }
            return Disposables.create()
        }
    }
    
    func sendInvitation(toNumber number: String) -> Single<Void> {
        return Single.create { observer in
            DispatchQueue.main.delay(1) {
                observer(.success(Void()))
            }
            return Disposables.create()
        }
    }
}
