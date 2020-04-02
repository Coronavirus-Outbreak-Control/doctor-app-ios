//
//  HelpViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 02/04/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import PMSuperButton

class HelpViewController: UIViewController {
    
    var scrollView: UIScrollView! = nil
    let howItWorksView: HowItWorksView = .fromNib()
    @IBOutlet weak var backButton: PMSuperButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // scroll view
        scrollView = UIScrollView(frame: view.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        let cc = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(cc)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        // howItWorksView
        howItWorksView.frame = view.bounds
        scrollView.addSubview(howItWorksView)
        howItWorksView.configure()
        howItWorksView.invalidateIntrinsicContentSize()
        
        backButton.map {
            $0.backgroundColor = .mainTheme
            $0.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.tintColor = .white
            view.bringSubviewToFront($0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: view.frame.size.width,
                                        height: howItWorksView.intrinsicContentSize.height)
    }
    
    @IBAction func actionBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
