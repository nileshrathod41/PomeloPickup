//
//  LocationService.swift
//  PomeloPickUp
//
//  Created by Nilesh on 19/08/20.
//  Copyright © 2020 Nilesh. All rights reserved.
//

import Foundation
import Alamofire

class LocationService {
    
    private let decoder = JSONDecoder()
    typealias Completion<T> = (RequestResult<T>) -> Void
    
    public func getAllLocation(completion: @escaping Completion<LocationInfoModel>) {
        
        let requestUrlString = "https://api-staging.pmlo.co/v3/pickup-locations/?shopID=1"
        
        AF.request(requestUrlString, headers: nil)
            .responseJSON { response in
                if response.error != nil {
                    completion(.failure(error: "Failed to fetch data"))
                } else {
                    do {
                        let results = try self.decoder.decode(LocationInfoModel.self, from: response.data ?? Data())
                        completion(.success(object: results))
                    } catch {
                        completion(.failure(error: "Failed to fetch data"))
                    }
                }
        }
    }
}
