//
//  NewGroup.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit
import Firebase

class MyFriendCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}

class NewGroup: UIViewController {

    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var locationTxtField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    
    var collectionData: [UIImage] = []
    var member: Member = Member(name: "", bitmoji: "")
    var addedFriendsList: [Member] = [Member(name: "Tim", bitmoji: "yes")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionData.append(UIImage(named: "addBtn")!)
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = (view.frame.size.width - 20) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addedFriendsList.append(member)
        print(addedFriendsList[0].name, addedFriendsList[1].name)
        collectionView.reloadData()
    }
    
    @IBAction func addGroupBtnPressed(_ sender: Any) {
        let name = nameTxtField.text
        let location = locationTxtField.text
        if name != nil && location != nil {
            let vc = MyGroupsViewController(nibName: "MyGroups", bundle: nil)
            vc.group = Group(name: name!, members: addedFriendsList, location: location!)
            self.navigationController?.popViewController(animated: false)
        }
    }
}
    
extension NewGroup: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyFriendCell
        cell.imageView.image = collectionData[indexPath.row]
        return cell
    }
}
    
extension NewGroup: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MyFriends")
            self.navigationController?.pushViewController(newViewController, animated: false)
        }
//        else {
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Group")
//            self.navigationController?.pushViewController(newViewController, animated: false)
//        }
    }
}

//    @IBAction func addLocationBtnPressed(_ sender: Any) {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Location")
//        self.navigationController?.pushViewController(newViewController, animated: false)
//    }
