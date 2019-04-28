//
//  Items.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/25/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import Foundation
import Firebase

class Items {
    var itemArray = [Item]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("items").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("**** ERROR: adding the snapsot listener \(error!.localizedDescription)")
                return completed()
            }
            self.itemArray = []
            for document in querySnapshot!.documents {
                let item = Item(dictionary: document.data())
                item.documentID = document.documentID
                self.itemArray.append(item)
            }
            completed()
        }
    }
}
