//
//  ApiUtils.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
class ApiUtils {
    
     
    enum PathUrl : String{
      case none = ""
      case login = "user/login"
    }

    
    
     static let baseApiUrl = "https://jawwal.arapeak.co/ar/api/"
    
    var version: String {
         return "v2"
     }
 
}
