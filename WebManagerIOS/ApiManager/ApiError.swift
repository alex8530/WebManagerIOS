//
//  ApiError.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct ApiError : Error {
  
    var errorMessage : String = ""
    var errorCode : Int = -1
}
