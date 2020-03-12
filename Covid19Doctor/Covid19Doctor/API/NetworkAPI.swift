//
//  NetworkAPI.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import RxSwift

protocol API {
    func checkPhoneNumber(_ number: String) -> Single<Bool>
}

class NetworkAPI: API {
    
    func checkPhoneNumber(_ number: String) -> Single<Bool> {
        return .just(true)
        //return .error(Errors.unknown)
    }
}
