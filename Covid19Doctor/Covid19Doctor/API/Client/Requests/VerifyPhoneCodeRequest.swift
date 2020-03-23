//
//  VerifyPhoneCodeRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 17/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct VerifyPhoneCodeRequest: NetworkRequest {
    let method = RequestType.GET
    let path: String
    let parameters = [String : String]()
    let body: Data? = nil
    let authToken: String? = nil
    
    init(code: String) {
        self.path = "activation/confirm/\(code)"
    }
}

struct VerifyPhoneCodeResponse: Codable {
    let id: Int
    let reAuthToken: String
}
