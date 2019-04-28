//
//  Item.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/25/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import Foundation
import Firebase

class Item {
    var name: String
    var price: Double
    var seller: String
    var contact: String
    var description: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "price": price, "seller": seller, "contact": contact, "description": description, "postingUserID": postingUserID]
    }
    
    init(name: String, price: Double, seller: String, contact: String, description: String, postingUserID: String, documentID: String) {
        self.name = name
        self.price = price
        self.seller = seller
        self.contact = contact
        self.description = description
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown user"
        self.init(name: "", price: 0.0, seller: "", contact: "", description: "", postingUserID: currentUserID, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let price = dictionary["price"] as! Double? ?? 0.0
        let seller = dictionary["seller"] as! String? ?? ""
        let contact = dictionary["contact"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, price: price, seller: seller, contact: contact, description: description, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
//        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
//            print("** ERROR: Couldnt save data because we don't have a valid user ID")
//            return completion(false)
//        }
//        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("items").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error{
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completion(false)
                } else{
                    print("Document updated with ref ID \(ref.documentID)")
                    completion(true)
                }
            }
        } else{
            var ref: DocumentReference? = nil
            ref = db.collection("items").addDocument(data: dataToSave) { error in
                if let error = error{
                    print("*** ERROR: creating new document \(self.documentID) \(error.localizedDescription)")
                    completion(false)
                } else{
                    print("Document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
    func deleteData(item: Item, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("items").document(self.documentID).delete()
            { error in
                if let error = error{
                    print("ERROR: deleting post documentID \(self.documentID) \(error.localizedDescription)")
                } else {
                        completed(true)
                    
                }
        }
    }
}
