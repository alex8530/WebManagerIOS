//
//  Pagination.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct Pagination  : Codable{
    
       var total: Int = 0
 
       var count: Int = 0
 
       var per_page: Int = 0
 
       var current_page: Int = 0
 
       var total_pages: Int = 0
}
