//
//  NewGroup.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class NewGroup: UIViewController {

    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var purposeTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addLocationBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Location")
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    @IBAction func addFriendsBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MyFriends")
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    @IBAction func addGroupBtnPressed(_ sender: Any) {
        let name = nameTxtField.text
        let purpose = purposeTxtField.text
        
    }
}
