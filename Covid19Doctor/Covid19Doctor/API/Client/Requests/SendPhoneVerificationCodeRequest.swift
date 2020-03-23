//
//  SendPhoneVerificationCodeRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 17/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct SendPhoneVerificationCodeRequest: NetworkRequest {
    let method = RequestType.POST
    let path = "activation/request"
    let parameters = [String : String]()
    let body: Data?
    let authToken: String? = nil
    
    init(phoneNumber: String) {
        let dict = ["phone_number" : phoneNumber]
        self.body = try! JSONSerialization.data(withJSONObject: dict)
    }
}
