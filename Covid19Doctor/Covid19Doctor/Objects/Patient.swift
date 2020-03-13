//
//  Patient.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

enum Covid19Status {
    case negative
    case positive
    case recovered
}

struct Patient {
    let id: String
    let covid19Status: Covid19Status
    // ...
}
