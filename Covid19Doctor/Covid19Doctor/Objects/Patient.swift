//
//  Patient.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

enum Covid19Status {
    case normal
    case infected
    case quarantine
    case healed
    case exposed
}

struct Patient {
    let id: String
    let covid19Status: Covid19Status
    // ...
}
