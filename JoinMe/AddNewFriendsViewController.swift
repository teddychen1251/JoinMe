//
//  AddNewFriendsViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit
import Contacts

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    
    var friends: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
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
        let cell = myTableView.cellForRow(at: indexPath)
        let bitmoji = cell?.textLabel?.text
        let name = cell?.detailTextLabel?.text
        
        let vc = NewGroup(nibName: "NewGroup", bundle: nil)
        vc.member = Member(name: name!, bitmoji: bitmoji!)
        
        self.navigationController?.popViewController(animated: false)
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
                        var formattedNumber = number.replacingOccurrences(of: "(", with: "")
                        formattedNumber = number.replacingOccurrences(of: ")", with: "")
                        formattedNumber = number.replacingOccurrences(of: " ", with: "")
                        formattedNumber = number.replacingOccurrences(of: "-", with: "")
                        print(formattedNumber)
                        if formattedNumber == "5556106679" {
                            self.friends.append(Member(name: (contact.givenName + " " + contact.familyName), bitmoji: "bitmoji link"))
                        }
                    })
                    
                }   catch let err {
                    print("Failed to enumerate contacts:", err)
                }
            }
            else {
                print("Access denied...")
            }
        }
        myTableView.reloadData()
    }
}
