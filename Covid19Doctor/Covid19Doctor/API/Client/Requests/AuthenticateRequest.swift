//
//  AuthenticateRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 23/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct AuthenticateRequest: NetworkRequest {
    let method = RequestType.POST
    let path: String = "authenticate"
    let parameters = [String : String]()
    let body: Data? = nil
    let authToken: String?
    
    init(reAuthToken: String) {
        self.authToken = reAuthToken
    }
}

struct AuthenticateResponse: Codable {
    let jwt: String
}
