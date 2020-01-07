//
//  Item.swift
//  MeriList
//
//  Created by Sharma, Neeraj on 1/5/20.
//  Copyright © 2020 Sharma, Neeraj. All rights reserved.
//

import Foundation

class Item: Codable {

    var done: Bool = false
    var name: String = ""
    
    init(name: String, checked: Bool) {
        self.name = name
        self.done = checked
    }

}
