//
//  Request.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/18/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class Request {
    
    // Send a GET request to the given URL
    static func send(url: String, completion: @escaping (URLResponse?, Data?) -> ()) {
        let url = URL(string: url)!
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                print(error ?? "no error")
                return
            }

            guard let data = data else {
                print("can't let data = data")
                return
            }
            
            completion(response, data)
        })
        task.resume()
    }
    
    // Send a GET request to the given URL, without a completion handler
    static func send(url: String) {
        let url = URL(string: url)!
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                print(error ?? "no error")
                return
            }
        })
        task.resume()
    }
    
}
