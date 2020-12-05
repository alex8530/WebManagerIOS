//
//  ApiWrapper.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
	


struct ApiWrapper<T:Codable> : Codable {

     var status: Bool? = false
     
     var message: String? = nil
     
     var errors: [[String]]? = nil
     
     var pagination : Pagination?=nil
    
     var data : T? = nil
}
