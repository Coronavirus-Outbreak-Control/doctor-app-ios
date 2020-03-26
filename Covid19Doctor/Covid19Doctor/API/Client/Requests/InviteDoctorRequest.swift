//
//  InviteDoctorRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 19/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct InviteDoctorRequest: NetworkRequest {
    let method = RequestType.POST
    let path: String = "activation/invite"
    let parameters = [String : String]()
    let body: Data?
    let authToken: String?
    
    init(authToken: String, phoneNumber: String) {
        self.authToken = authToken
        let dict = ["phone_number": phoneNumber]
        self.body = try! JSONSerialization.data(withJSONObject: dict)
    }
}
