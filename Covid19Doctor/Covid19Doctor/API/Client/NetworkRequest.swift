//
//  NetworkRequest.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 17/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol NetworkRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
    var body: Data? { get }
    var authToken: String? { get }
}

extension NetworkRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        if let authToken = authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
