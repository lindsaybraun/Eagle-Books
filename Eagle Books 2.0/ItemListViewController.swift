//
//  ItemListViewController.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/25/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var items: Items!
    var item: Item!
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        items = Items()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        item.name = nameTextField.text!
//        //item.price = Double(priceTextField.text)!
//        item.seller = sellerTextField.text!
//        item.contact = contactTextField.text!
//        item.description = descriptionTextField.text!
        switch segue.identifier ?? "" {
        case "AddItem":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! ItemDetailTableViewController
            destination.item = item
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        case "ShowItem":
            let destination = segue.destination as! ItemDetailTableViewController
            destination.item = item
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.item = items.itemArray[(selectedIndexPath.row)]
        default:
            print("*** ERROR: Did not have a segue in ItemDetailTableViewController prepare(for segue)")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowItem" {
//            let destination = segue.destination as! ItemDetailViewController
//            let selectedIndexPath = tableView.indexPathForSelectedRow
//            destination.item = items.itemArray[(selectedIndexPath?.row)!]
//        } else {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                tableView.deselectRow(at: selectedIndexPath, animated: true)
//            }
//        }
//    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^^ Successfully signed out!")
            tableView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
            print("**** ERROR: Couldn't sign out!")
        }
        
    }
    

}

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.itemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items.itemArray[indexPath.row].name
        var price = String((items.itemArray[indexPath.row].price))
        cell.detailTextLabel?.text = "$" + price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ItemListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            tableView.isHidden = false
            print("*** We signed in the the user \(user.email ?? "unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        let marginInsets: CGFloat = 4
        let imageHeight: CGFloat = 450
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets * 2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.center = self.view.center
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}
