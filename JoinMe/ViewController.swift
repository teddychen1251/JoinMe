//
//  ViewController.swift
//  JoinMe
//
//  Created by Teddy Chen on 10/19/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit
import Firebase

class MyCell: UICollectionViewCell {
    @IBOutlet var groupLabel: UILabel!
}

class MyGroupsViewController: UIViewController {
    
    var db: Firestore!
    var user: DocumentReference!

    var collectionData: [Group] = [Group(name: "+", members: [], location: "")]
    
    @IBOutlet var collectionView: UICollectionView!
    
    var group: Group = Group(name: "", members: [], location: "")
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = (view.frame.size.width - 20) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if group.name != "" {
            collectionData.insert(group, at: 0)
            for it in collectionData {
                print(it.name)
            }
            collectionView.reloadData()
        }
    }
}

extension MyGroupsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.groupLabel.text = collectionData[indexPath.row].name
        return cell
    }
}

extension MyGroupsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewGroup")
            self.navigationController?.pushViewController(newViewController, animated: false)
        }
        else {
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Group")
            self.navigationController?.pushViewController(newViewController, animated: false)
        }
    }
}

