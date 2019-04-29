//
//  ItemDetailTableViewController.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/28/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import UIKit
import Firebase

class ItemDetailTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sellerTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTextField.delegate = self
        saveBarButton.isEnabled = false
        
        //hide keyboard if tap outside of field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if item == nil { // adding a new item, field should be editable
            item = Item()
            //editable field has border around it
            addBordersToEditableObjects()
            deleteButton.isHidden = true
            
            
        } else { //viewing existing item so editing should be disabled
            if item.postingUserID == Auth.auth().currentUser?.email {
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                saveBarButton.isEnabled = true
                addBordersToEditableObjects()
                deleteButton.isHidden = false
                
            } else {
                nameTextField.isEnabled = false
                priceTextField.isEnabled = false
                sellerTextField.isEnabled = false
                contactTextField.isEnabled = false
                descriptionTextField.isEditable = false
                nameTextField.backgroundColor = UIColor.clear
                priceTextField.backgroundColor = UIColor.clear
                sellerTextField.backgroundColor = UIColor.clear
                contactTextField.backgroundColor = UIColor.clear
                descriptionTextField.backgroundColor = UIColor.clear
                nameTextField.noBorder()
                priceTextField.noBorder()
                sellerTextField.noBorder()
                contactTextField.noBorder()
                descriptionTextField.noBorder()
                saveBarButton.title = ""
                cancelBarButton.title = ""
                deleteButton.isHidden = true
            }
            
        }
        nameTextField.text = item.name
        priceTextField.text = String(item.price)
        sellerTextField.text = item.seller
        contactTextField.text = item.contact
        descriptionTextField.text = item.description
        
    }
    
    func leaveViewController () {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func addBordersToEditableObjects() {
        nameTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        priceTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        sellerTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        contactTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        descriptionTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (contactTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty{
            saveBarButton?.isEnabled = true
        } else {
            saveBarButton?.isEnabled = false
        }
        return true
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        item.name = nameTextField.text!
        item.price = Double(priceTextField.text!)!
        item.seller = sellerTextField.text!
        item.contact = contactTextField.text!
        item.description = descriptionTextField.text!
        item.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("**** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        item.deleteData(item: item) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: delete unsuccessful")
            }
        }
    }
    
    @IBAction func nameReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func priceReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func sellerReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func contactReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if contactTextField.text != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        if (nameTextField.text?.isEmpty)! {
            saveBarButton.isEnabled = false
        }
    }
}

