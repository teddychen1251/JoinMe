//
//  LoginViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Kingfisher
import Firebase



struct SnapUserInfo {
    let displayName: String
    let url: URL
}

extension UIViewController {
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

class LoginViewController: UIViewController {

    var db: Firestore!
    var usersRef: CollectionReference!
    var user: DocumentReference!
    
    @IBOutlet weak var bitMji: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        user.setData(["displayName": txtField.text!], mergeFields: ["displayName"])
    }
    
    private func fetchSnapUserInfo(completionBlock:@escaping (SnapUserInfo)->()){
            
        var ret:String = ""
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
            
        let variables = ["page": "bitmoji"]
            
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
                
            let displayName = me["displayName"] as? String
            ret = displayName!
                
                
            if let bitmoji = me["bitmoji"] as? [String: Any],
                let urlString = bitmoji["avatar"] as? String,
                let url = URL(string: urlString)
            {
                let userInfo = SnapUserInfo(displayName: ret, url: url)
                completionBlock(userInfo)
            } else {
                // error handling
            }
                
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
            
            
    }

    @IBAction func snapchatLoginAction(_ sender: Any) {
        SCSDKLoginClient.login(from: self) { success, error in
            if let error = error {
                // An error occurred during the login process
                print(error.localizedDescription)
            } else {
                // The login was a success! This user is now
                // authenticated with Snapchat!
                self.fetchSnapUserInfo(completionBlock: { (userInfo) in
                    DispatchQueue.main.async {
                        self.setTxtField(s: userInfo.displayName)
                        self.setBitmoji(u: userInfo.url)
                        self.enterButton.isHidden = false
                    }
                    self.usersRef.getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            var unique = true
                            for document in querySnapshot!.documents {
                                if (document.get("bitmoji_id") as? String ?? "") == userInfo.url.path {
                                    unique = false
                                    self.user = document.reference //self.usersRef.document(document.documentID)
                                    break
                                }
                            }
                            if unique {
                                self.user = self.addUserToDatabase(info: userInfo)
                            }
                        }
                    }
                })
            }
        }
    }
    
    private func addUserToDatabase(info: SnapUserInfo) -> DocumentReference { //eventually assign bitmojiIDs as doc ID to easily check if new user is unique
        return self.usersRef.addDocument(data: [
            "username": info.displayName,
            "displayName": info.displayName,
            "bitmoji_url": info.url.absoluteString, //NSURL not supported
            "bitmoji_id": info.url.path
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("User document added!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        usersRef = db.collection("users")
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
    
    func setTxtField(s:String) {
        txtField.text = s
    }
    
    func setBitmoji(u:URL) {
        bitMji.kf.setImage(with: u)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! NewGroup
        dvc.user = user
        dvc.db = db
    }

}
