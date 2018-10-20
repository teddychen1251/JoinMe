//
//  ViewController.swift
//  JoinMe
//
//  Created by Teddy Chen on 10/19/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    @IBOutlet var groupLabel: UILabel!
}

class MyGroupsViewController: UIViewController {
    
    var collectionData = ["1", "2", "3"]
    
    
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionData.append("+")
        
        let width = (view.frame.size.width - 20) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        cell.groupLabel.text = collectionData[indexPath.row]
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

