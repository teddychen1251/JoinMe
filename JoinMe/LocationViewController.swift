//
//  LocationViewController.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class LocationViewController: UITableViewController, UISearchBarDelegate {
    
    var locations: [String] = []
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.sizeToFit()
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let location = locations[indexPath.row]
        cell.textLabel?.text = location
        //cell.detailTextLabel?.text = song.displayTrackTime
        return cell
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        SongDownloader.downloadSongs(searchTerm: searchBar.text!) { (songs)
//            in
//            // songs that were passed in - go back to main thread to run this
//            DispatchQueue.main.async {
//                self.locations = locations
//                self.tableView.reloadData()
//            }
//        }
//    }
}
