//
//  ViewController.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var parameters: [String: Any] = [:]
        
        //    parameters["mobile"] = 1010101
        parameters["password"] = 101010
        
        
        
        let apiManager =  ApiManager<ApiWrapper<User>>.Builder(pathUrl: .login, reqMethod: .post)
            .withParameters(parameters: parameters)
            .build()
        
        apiManager.start(
            onStart: {
                //show progress
                
        }, onFinish: {
            //hide progress
            
        }, completion: { (apiWrapper, apiError) in
            if apiError != nil {
                
                //error when code not 200(500,422,401..)
                print(apiError?.errorMessage ?? "")
                
                if apiError?.errorCode == 401 {
                    //clear UserDefault And SignOut
                }
                
            }else{
                //if code == 200 , then check on status of response itself
                
                if let _apiWrapper = apiWrapper {
                    if _apiWrapper.status ?? false == true {
                        //success
                        print( _apiWrapper.message ?? "")
                    }else{
                        //fail
                        print( _apiWrapper.message ?? "")
                    }
                    
                }
                
            }
            
            
        })
    }
    
    
}


