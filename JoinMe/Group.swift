//
//  Group.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class Group: NSObject {
    
    var name: String
    var members: [Member]
    var location: String
    
    init(name: String, members: [Member], location: String) {
        self.name = name
        self.members = members
        self.location = location
    }
    
}
