//
//  SetPatientStatusRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 21/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct SetPatientStatusRequest: NetworkRequest {
    let method = RequestType.POST
    let path: String
    let parameters = [String : String]()
    let body: Data? = nil
    let authToken: String?
    
    init(authToken: String, patientId: String, newStatus: PatientStatus) {
        self.authToken = authToken
        self.path = "mark/\(patientId)/\(newStatus)"
    }
}
