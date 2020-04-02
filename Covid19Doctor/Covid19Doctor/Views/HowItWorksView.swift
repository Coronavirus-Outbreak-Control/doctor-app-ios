//
//  HowItWorksView.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 02/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit

class HowItWorksView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var a0: UILabel!
    @IBOutlet weak var q1: UILabel!
    @IBOutlet weak var a1: UILabel!
    @IBOutlet weak var q2: UILabel!
    @IBOutlet weak var a2: UILabel!

    @IBOutlet weak var lastView: UIView!
    
    func configure() {
        let fontQ = UIFont(name: "SFCompactDisplay-Bold", size: 17)
        let fontA = UIFont(name: "SFCompactDisplay-Regular", size: 17)
        
        titleLabel.map {
            $0.text = NSLocalizedString("how_it_works", comment: "")
            $0.font = UIFont(name: "SFCompactDisplay-Heavy", size: 38)
            $0.textColor = .titleBlack
        }
        
        a0.map {
            $0.text = NSLocalizedString("how_it_works_p0", comment: "")
            $0.font = fontA
            $0.textColor = .titleBlack
        }
        
        q1.map {
            $0.text = NSLocalizedString("how_it_works_q1", comment: "")
            $0.font = fontQ
            $0.textColor = .titleBlack
        }
        
        a1.map {
            $0.text = NSLocalizedString("how_it_works_p1", comment: "")
            $0.font = fontA
            $0.textColor = .titleBlack
        }
        
        q2.map {
            $0.text = NSLocalizedString("how_it_works_q2", comment: "")
            $0.font = fontQ
            $0.textColor = .titleBlack
        }
        
        a2.map {
            $0.text = NSLocalizedString("how_it_works_p2", comment: "")
            $0.font = fontA
            $0.textColor = .titleBlack
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width,
                      height: lastView.frame.origin.y)
    }
}
