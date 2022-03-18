//
//  NewContactViewController.swift
//  ContactList
//
//  Created by MarkYu on 2022/3/3.
//

import UIKit

class NewContactViewController: UIViewController {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var firstNameTextfield: UITextField!
    @IBOutlet var lastNameTextfield: UITextField!
    @IBOutlet var phoneTextfield: UITextField!
    
    var viewModel: NewContactViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTable()
        setupViews()
        photoImageView.makeRounded()
        firstNameTextfield.becomeFirstResponder()
        phoneTextfield.delegate = self
    }

    // MARK: - Connect to database and create table
    private func createTable(){
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    // MARK: - Setup the views with the values of the selected contact
    private func setupViews() {
        if let viewModel = viewModel {
            firstNameTextfield.text = viewModel.firstName
            lastNameTextfield.text = viewModel.lastName
            phoneTextfield.text = viewModel.phoneNumber
            photoImageView.image = viewModel.photo
        }
    }
    
    // MARK: - Save new contact or update an existing contact
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let firstName = firstNameTextfield.text ?? ""
        let lastName = lastNameTextfield.text ?? ""
        let phoneNumber = phoneTextfield.text ?? ""
        let uiImage = photoImageView.image ?? UIImage(systemName: "person")
        guard let photo = uiImage?.pngData() else {return}
        let contactValues = Contact(id: id,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNumber: phoneNumber,
                                    photo: photo)
        
        // If viewmodel equal to nil a new contact will be created, otherwise an existing contact will be updated,
        if viewModel == nil {
            // Contact Creat
            createNewContact(contactValues)
        } else {
            // Contact Updated
            updateContact(contactValues)
        }
        
        
        SQLiteCommands.presentRows()
    }
    
    // MARK: - Create new contact
    
    private func createNewContact(_ contactValues: Contact) {
        let contactAddedToTable = SQLiteCommands.insertRow(contactValues)
        
        // Phone Number is unique to each contact so we check if it already exists
        if contactAddedToTable == true {
            dismiss(animated: true, completion: nil)
        } else {
            showError(title: "Error", message: "This Contact cannot be created because this phoneNumber already exist in your contact list.")
        }
    }
    
    // MARK: - Update Contact
    private func updateContact(_ contactValues: Contact) {
        let contactUpdatedInTable = SQLiteCommands.updatingRow(contactValues)
        
        //Phone Number is unique to each contact so we check if it already exists
        if contactUpdatedInTable == true {
            if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            }
        } else {
            showError(title: "Error", message: "This contact cannot be updated because this phone number already exist in your contact list")
        }
    }
    
    // MARK: - Cancel Button
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let addButtonClicked = presentingViewController is UINavigationController
        
        // If the user clicked add button on the previous screen
        if addButtonClicked {
            // dismisses to the previous screen with animation
            dismiss(animated: true, completion: nil)
        }
        // If the user clicked on a cell on the previous screen
        else if let cellClicked = navigationController {
            cellClicked.popViewController(animated: true)
        }
        else {
            print("The ContactScreenTableViewController is not inside a navigation controller")
        }
    }
    

    @IBAction func addImage(_ sender: UITapGestureRecognizer) {

    }
    @IBAction func addImageFromPhotoLibraryButtonTapped(_ sender: Any) {
        print("asddas")
        // let the user pick media from his photo library
        let imagePickerController = UIImagePickerController()
        
        // Allows to pick photos.
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Image Tap gesture
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension NewContactViewController: UITextFieldDelegate {
    // MARK: - Phone Number Validation
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]",
                                                with: "",
                                                options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XX) XXXX-XXXX", phone: newString)
        return false
        
    }
}
