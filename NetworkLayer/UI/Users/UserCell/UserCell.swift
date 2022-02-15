//
//  UserCell.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 2/15/22.
//

import UIKit
import Reusable

class UserCell: UITableViewCell, NibReusable {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        resetValues()
    }

    var user: UserModel? {
        didSet {
            self.resetValues()
            if let user = user {
                firstNameLabel.text = user.firstName
                lastNameLabel.text = user.lastName
                dateOfBirthLabel.text = user.dateOfBirth?.displayString
            }
        }
    }

    func resetValues() {
        firstNameLabel.text = ""
        lastNameLabel.text = ""
        dateOfBirthLabel.text = ""
    }
}

