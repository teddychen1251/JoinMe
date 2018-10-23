//
//  Member.swift
//  JoinMe
//
//  Created by Tim Tan on 10/20/18.
//  Copyright © 2018 Teddy Chen. All rights reserved.
//

import UIKit

class Member: NSObject {
    var name: String
    var bitmoji: String
    
    init(name: String, bitmoji: String) {
        self.name = name
        self.bitmoji = bitmoji
    }
}
