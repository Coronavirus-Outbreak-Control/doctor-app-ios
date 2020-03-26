//
//  NetworkClient.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 17/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import Foundation
import RxSwift

class NetworkClient {
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func send<T: Codable>(apiRequest: NetworkRequest) -> Single<T> {
        return Single<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let status = (response as? HTTPURLResponse)?.statusCode else {
                    observer(.error(Errors.unknown))
                    return
                }
                
                // check response code and return on error if any
                switch status {
                case 200..<299:
                    break
                default:
                    observer(.error(Errors.requestFailed(status)))
                    return
                }
                
                if let error = error {
                    observer(.error(error))
                } else {
                    if T.self == Empty.self {
                        observer(.success(Empty() as! T))
                    } else {
                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                            observer(.success(model))
                        } catch let error {
                            observer(.error(error))
                        }
                    }
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
