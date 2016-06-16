//
//  TVData.swift
//  PhotoShare
//
//  Created by Om on 5/3/16.
//  Copyright © 2016 Samsung. All rights reserved.
//

import Foundation



struct TV
{
    var Name:String?
    
    init(name:String?)
    {
        self.Name = name;
        
    }

}
let TVData = [
    TV(name: "TV1"),
    TV(name: "TV2"),
    TV(name: "TV3")
    
]