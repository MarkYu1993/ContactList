//
//  UIImageView.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/3.
//

import UIKit

extension UIImageView {
    // Round shaped Image
    func makeRounded(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
