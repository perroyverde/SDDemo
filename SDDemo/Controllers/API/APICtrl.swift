//
//  ConnectionController.swift
//  SDDemo
//
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct APICtrl {
    
    /// Manager for requests. Here are defined server trust policies and exceptions
    private static var manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["netflixroulette.net": .disableEvaluation]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    private static func genericRequest(url: String, completionHandler: @escaping (Any?, NSError?) -> ()) {
        
        APICtrl.manager
            .request(url)
            .validate().responseJSON { reponse in
                
                switch reponse.result {
                case .success(let value): completionHandler(value, nil)
                case .failure(let error): completionHandler(nil, error as NSError?)
                }
        }
    }
    
    public static func requestMovies(fromDirector director: String, completionHandler: @escaping (Array<Movie>?, Error?) -> ()) {
        
        let encodedDirName = director.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        
        genericRequest(url: "https://netflixroulette.net/api/api.php?director=\(encodedDirName)",
                       completionHandler: { response, error in
                        
                        if (nil == error || error?.code == 0) {
                            
                            let movies : Array<Movie> = Mapper<Movie>().mapArray(JSONObject: response) ?? []
                            completionHandler(movies, nil)
                            return
                            
                        } else {
                            completionHandler(nil, error)
                        }
        })
    }


}
