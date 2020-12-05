//
//  ApiManager.swift
//  WebManagerIOS
//
//  Created by Alex on 12/4/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Alamofire



class ApiManager<T:Codable>  {
    
    
    private(set) var baseUrl:String = ApiUtils.baseApiUrl
    private(set) var headers = [String : String]()
    private(set) var parameters = [String : Any]()
    private(set) var reqMethod: HTTPMethod = .get
    private(set) var pathUrl: ApiUtils.PathUrl = .none
    private(set) var token: String?=nil
    private(set) var encoding: ParameterEncoding = URLEncoding.default
    
    
    
    
    private init(builder :Builder ) {
        self.headers =  builder.headers
        self.parameters =  builder.parameters
        self.encoding =  builder.encoding
        self.pathUrl=builder.pathUrl
        self.token = builder.token
        self.reqMethod =  builder.reqMethod
    }
    
    private func getFullUrl()->String{
        return self.baseUrl + self.pathUrl.rawValue
    }
    
    
    func start(
        onStart : @escaping () -> Void,
        onFinish : @escaping () -> Void,
        completion: @escaping ((T?,ApiError?)->Void)
    ) {
        
        onStart()
        
        Alamofire.request(getFullUrl(), method: self.reqMethod, parameters: self.parameters, encoding: self.encoding, headers: self.headers) .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"]).responseJSON {
                (response) in
                
                if(response.result.isSuccess){
                    
                    do {
                        let responseData =  try JSONDecoder().decode(T.self, from: response.data!)
                        
                        print("Success : \r\n----\(response) ----")
                        completion(responseData,nil)
                    } catch let jsonErr {
                        print("Error serializing  respone json", jsonErr)
                        completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode:  -1))
                    }
                    
                    
                }else{
                    
                    do {
                        var statusCode = response.response?.statusCode
                        if let _statusCode = statusCode {
                            
                            if _statusCode == 401 {
                                print("401 error --------")
                                completion(nil,ApiError(errorMessage: "un auth", errorCode: _statusCode))
                            }else  if let error = response.result.error as? AFError {
                                
                                switch error {
                                case .invalidURL(let url):
                                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                                    completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                                case .parameterEncodingFailed(let reason):
                                    print("Parameter encoding failed: \(error.localizedDescription)")
                                    print("Failure Reason: \(reason)")
                                    completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                                case .multipartEncodingFailed(let reason):
                                    print("Multipart encoding failed: \(error.localizedDescription)")
                                    print("Failure Reason: \(reason)")
                                    completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                                case .responseValidationFailed(let reason):
                                    //todo parse and get errors
                                    print("Response validation failed: \(error.localizedDescription)")
                                    print("Failure Reason: \(reason)")
                                    
                                    
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String : Any]
                                        
                                        let errors = json?["errors"] as? [[String]]
                                        if let _errors = errors {
                                            
                                            completion(nil,ApiError(errorMessage: _errors.description.getStringMessageFromApiErrorValidation(), errorCode: _statusCode))
                                        }
                                        
                                    } catch let error {
                                        print("\(error)")
                                        
                                        completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                                    }
                                    
                                    switch reason {
                                    case .dataFileNil, .dataFileReadFailed:
                                        print("Downloaded file could not be read")
                                    case .missingContentType(let acceptableContentTypes):
                                        print("Content Type Missing: \(acceptableContentTypes)")
                                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                                    case .unacceptableStatusCode(let code):
                                        print("Response status code was unacceptable: \(code)")
                                        statusCode = code
                                    }
                                    
                                    
                                case .responseSerializationFailed(let reason):
                                    print("Response serialization failed: \(error.localizedDescription)")
                                    print("Failure Reason: \(reason)")
                                    
                                    completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                                    
                                }
                                
                                print("Underlying error: ")
                            } else if let error = response.result.error as? URLError {
                                print("URLError occurred: \(error)")
                                completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                            } else {
                                print("Unknown error:  )")
                                completion(nil,ApiError(errorMessage: "There was a problem, try Agin",errorCode: _statusCode))
                            }
                            
                            
                        }
                        
                        
                    }
                }
                
                onFinish()
        }
        
        
    }
    public class Builder {
        
        private(set) var baseUrl:String = ApiUtils.baseApiUrl
        private(set) var headers = [String : String]()
        private(set)  var parameters = [String : Any]()
        private(set) var reqMethod: HTTPMethod = .get
        private(set) var pathUrl: ApiUtils.PathUrl = .none
        private(set) var token: String?=nil
        private(set) var encoding: ParameterEncoding = URLEncoding.default
        
        
        
        init(pathUrl: ApiUtils.PathUrl ,reqMethod : HTTPMethod = .get   ) {
            self.pathUrl =   pathUrl
            self.reqMethod = reqMethod
        }
        
        func withBaseUrl(baseUrl : String) -> Builder {
            self.baseUrl =  baseUrl
            return self
        }
        
        
        func withHeaders(headers : [String : String]) -> Builder {
            self.headers =  headers
            return self
        }
        
        
        func withParameters(parameters : [String : Any]) -> Builder {
            self.parameters =  parameters
            return self
        }
        
        
        func withEncoding(encoding : ParameterEncoding) -> Builder {
            self.encoding =  encoding
            return self
        }
        
        
        
        func withTocken(token : String) -> Builder {
            self.token =  token
            return self
        }
        
        
        func build() -> ApiManager {
            
            
            if headers.count > 0 {
                for (key, value) in headers {
                    self.headers[key] = value
                }
            }
            
             
            self.headers["Content-Type"] = "application/x-www-form-urlencoded"
            self.headers["Accept"] = "application/json"
            
            
            if let _token = self.token , !_token.isEmpty{
                self.headers["Authorization"] = "Bearer \(_token)"
            }
            
            print("headers =\(self.headers)\r\n")
            
            
            if parameters.count > 0 {
                self.generateParametersForHttpBody(parameters: parameters)
            }
            
            
            return  ApiManager(builder: self)
        }
        
        private func generateParametersForHttpBody(parameters: [String: Any]) {
            print("\r\n---- START OF REQUEST PARAMETERS ----")
            for (key, value) in parameters {
                self.parameters[key] = value
                print("\(key)=\(value)\r\n")
            }
        }
        
        
    }
}


extension String {
    
    func getStringMessageFromApiErrorValidation( ) -> String {
        
        return self.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: ", ", with: "\n")
            .replacingOccurrences(of: " ,", with: "\n")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "'", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
