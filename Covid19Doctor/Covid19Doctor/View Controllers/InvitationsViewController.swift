//
//  InvitationsViewController.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 21/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import RealmSwift

class InvitationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var invitations: Results<InvitationObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Invitations sent"

        let realm = Database.shared.realm()
        invitations = realm.objects(InvitationObject.self).sorted(byKeyPath: "date", ascending: false)
    }
}

extension InvitationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        invitations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let invitation = invitations?[indexPath.row] else {
            // should never happen
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InvitationCell
        cell.nameLabel.text = invitation.contactName
        cell.phoneNumberLabel.text = invitation.phoneNumber
        cell.dateLabel.text = "" // TODO
        return cell
    }
}

extension InvitationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
