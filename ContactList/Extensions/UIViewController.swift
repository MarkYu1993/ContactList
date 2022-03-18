//
//  UIViewController.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/3.
//

import UIKit

extension UIViewController {
    // Alert
    func showError(title: String?, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
