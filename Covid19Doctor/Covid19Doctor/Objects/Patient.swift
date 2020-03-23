//
//  Patient.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 13/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

enum PatientStatus: Int {
    case normal =       0
    case infected =     1
    case suspected =    2
    case healed =       3
    case quarantineLight =      4
    case quarantineWarning =    5
    case quarantineAlert =      6
    
}

struct Patient {
    let id: String
    let status: PatientStatus
    // ...
}
