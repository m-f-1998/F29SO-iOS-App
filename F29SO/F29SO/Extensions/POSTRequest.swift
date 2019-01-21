//
//  POSTRequest.swift
//  F29SO
//
//  Created by Matthew on 20/11/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    
    enum RESTMethod: String { // HTTP method for request
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    private func getPostString(params: [String : Any]) -> String { // Parse query string for POST request
        var data: [String] = [String]()
        for(key, value) in params {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func sendRequest(_ url: String, method: RESTMethod, parameters: [String : Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask! { //Make generic POST request
        let requestURL: URL = URL(string: url)!
        let parameterString: Data? = getPostString(params: parameters).data(using: .utf8)
        
        var request = URLRequest(url: requestURL)
        request.httpBody = parameterString
        request.httpMethod = method.rawValue
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data,response,error) // Completition Done Through In Line Method
        }
        task.resume()
        
        return task
    }
    
}
