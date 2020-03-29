//
//  HowItWorksViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 29/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton

class HowItWorksViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var text5: UILabel!
    
    @IBOutlet weak var backButton: PMSuperButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontQ = UIFont(name: "SFCompactDisplay-Bold", size: 17)
        let fontA = UIFont(name: "SFCompactDisplay-Regular", size: 17)
        
        backButton.map {
            $0.backgroundColor = .mainTheme
            $0.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.tintColor = .white
        }

        titleLabel.map {
            $0.text = "Come funziona 🤔"
            $0.font = UIFont(name: "SFCompactDisplay-Heavy", size: 38)
            $0.textColor = .titleBlack
        }
        
        text1.map {
            $0.text = "Useremo la fotocamera del tuo cellulare e i contatti, per permetterti di scansionare i codici QR dei pazienti e invitare altri dottori."
            $0.font = fontA
            $0.textColor = .titleBlack
        }
        
        text2.map {
            $0.text = "Come posso aiutare?"
            $0.font = fontQ
            $0.textColor = .titleBlack
        }
        
        text3.map {
            $0.text = "Puoi registrare lo stato di salute del paziente in modo da notificare altre persone che hanno interagito con il paziente."
            $0.font = fontA
            $0.textColor = .titleBlack
        }
        
        text4.map {
            $0.text = "Come posso promuovere questa app?"
            $0.font = fontQ
            $0.textColor = .titleBlack
        }
        
        text5.map {
            $0.text = "Puoi invitare altri dottori fidati inviandoci il loro numero di telefono."
            $0.font = fontA
            $0.textColor = .titleBlack
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
