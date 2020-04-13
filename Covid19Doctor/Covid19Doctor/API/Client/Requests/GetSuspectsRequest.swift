//
//  GetSuspectsRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

struct GetSuspectsRequest: NetworkRequest {
    let method = RequestType.GET
    let path: String
    var parameters = [String : String]()
    let body: Data? = nil
    let authToken: String?
    
    init(authToken: String, doctorId: String) {
        self.authToken = authToken
        self.path = "patient/suspect/\(doctorId)"
    }
}

struct GetSuspectsResponse: Codable {
    let data: [SuspectRecord]
}

struct SuspectRecord: Codable {
    let patient_id: Int
}
