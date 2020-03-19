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
    
    init(code: String, token: String) {
        self.path = "/activation/confirm/\(code)/\(token)"
    }
}

struct VerifyPhoneCodeResponse: Codable {
    let id: Int
    let authToken: String
}
