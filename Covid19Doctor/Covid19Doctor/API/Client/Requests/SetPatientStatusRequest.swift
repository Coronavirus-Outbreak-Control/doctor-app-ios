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
    var parameters = [String : String]()
    let body: Data? = nil
    let authToken: String?
    
    init(authToken: String, patientId: String,
         newStatus: PatientStatus,
         ignoreStatusCheck: Bool = false) {
        self.authToken = authToken
        self.path = "mark/\(patientId)/\(newStatus.rawValue)"
        self.parameters["ignore_status_check"] = "\(ignoreStatusCheck)"
    }
}
