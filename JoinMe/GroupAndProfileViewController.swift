//
//  GroupAndProfileViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/21/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class MyGroupCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}

class GroupAndProfileViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var collectionData: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

class Profile: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
}

extension GroupAndProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyFriendCell
        let bitmojiImage = UIImageView()
        bitmojiImage.kf.setImage(with: URL(string: friends[indexPath.row].bitmoji))
        let userPic: UIImage = bitmojiImage.image ?? UIImage(named: "testBitmoji")!
        cell.imageView.image = userPic
        return cell
    }
}

extension GroupAndProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Profile")
        self.navigationController?.pushViewController(newViewController, animated: false)
        
    }
}
