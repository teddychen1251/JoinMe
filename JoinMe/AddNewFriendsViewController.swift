//
//  AddNewFriendsViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit
import Contacts
import Firebase

var friends: [Member] = []

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    
    var userContacts: [String] = []
    
    var db: Firestore!
    var usersRef: CollectionReference!
    
    var member = Member(name: "", bitmoji: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        usersRef = db.collection("users")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.bitmoji
        cell.detailTextLabel?.text = friend.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: false)
        
        //        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        if let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "NewGroup") as? NewGroup {
        //            homeViewController.member = Member(name: name!, bitmoji: bitmoji!)
        //            self.present(homeViewController, animated: false)
        //        }
    }
    
    func fetchContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access:", err)
                return
            }
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        let number = contact.phoneNumbers.first?.value.stringValue ?? ""
                        var formattedNumber = number.replacingOccurrences(of: " ", with: "")
                        formattedNumber = formattedNumber.replacingOccurrences(of: "(", with: "")
                        formattedNumber = formattedNumber.replacingOccurrences(of: ")", with: "")
                        formattedNumber = formattedNumber.replacingOccurrences(of: "-", with: "")
                        self.userContacts.append(formattedNumber)
                    })
                    
                }   catch let err {
                    print("Failed to enumerate contacts:", err)
                }
            }
            else {
                print("Access denied...")
            }
        }
        DispatchQueue.main.async {
            self.usersRef.getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let num = document.get("phone_num") as? String ?? ""
                        for userNum in self.userContacts {
                            if userNum == num {
                                print("Got em")
                                let displayName = document.get("displayName") as? String ?? ""
                                let bitmojiUrl = document.get("bitmoji_url") as? String ?? ""
                                //document.reference.setData(["friends": "placehold"], merge: true)
                                
                                if friends.count == 0 {
                                    friends.append(Member(name: displayName, bitmoji: bitmojiUrl))
                                }
                                
                                for friend in friends {
                                    print(friend.bitmoji, bitmojiUrl)
                                    if friend.bitmoji != bitmojiUrl {
                                        friends.append(Member(name: displayName, bitmoji: bitmojiUrl))
                                    }
                                }
                            }
                        }
                        self.myTableView.reloadData()
                    }
                }
            }
        }
    }
}
