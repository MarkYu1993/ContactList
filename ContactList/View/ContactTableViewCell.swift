//
//  ContactTableViewCell.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/4.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var contactPhotoImageVIew: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var contactPhoneNumberLabel: UILabel!
    
    //Setup contact values
    func setCellWithValuesOf(_ contact: Contact){
        contactNameLabel.text = contact.firstName + " " + contact.lastName
        contactPhoneNumberLabel.text = contact.phoneNumber
        let image = UIImage(data: contact.photo)
        contactPhotoImageVIew.image = image
        contactPhotoImageVIew.makeRounded()
        
    }

}
