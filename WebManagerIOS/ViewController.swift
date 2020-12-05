//
//  ViewController.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

struct ImageUpload  : Codable{
    var id : Int = 0
}

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
       // sendLogin()
       // uploadImage()
         
       
    }
   
    
    
    func uploadImage(){
        
        let image = UIImage(named: "backImage")
        let imageData = image?.jpegData(compressionQuality: 0.2)
        if let _imageData = imageData {
            let apiManager =  ApiManager<ImageUpload>.Builder(pathUrl: .uploadImage, reqMethod: .post)
                       .withAddFile(
                           data: _imageData,
                           partName: "image" ,
                           mimeType: .image,
                           extentionName: "JPG"
                       ).build()
                   
                   apiManager.startAsMultiPart(onStart: {
                       print("start>>")
                   }, onProgress: { (progress) in
                       print("progress :: \(progress)")
                   }, onFinish: {
                       print("finish>>>")
                   }) { (respone, apiError) in
                       if apiError != nil {
                                  
                          //error when code not 200 >> (500,422,401..)
                          print(apiError?.errorMessage ?? "")
                          
                          if apiError?.errorCode == 401 {
                              //clear UserDefault And SignOut
                          }
                          
                      }else{
            
                        //success
                         print(respone?.id)
                      }
                 
              }
        }
       
        
    }
    
    func sendLogin() {
        var parameters: [String: Any] = [:]
        
        //parameters["mobile"] = 1010101
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


