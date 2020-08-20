//
//  LocationInfoModel.swift
//  PomeloPickUp
//
//  Created by Nilesh on 19/08/20.
//  Copyright © 2020 Nilesh. All rights reserved.
//

import Foundation
import CoreLocation

enum RequestResult<T> {
    case success(object: T)
    case failure(error: String)
}

class LocationInfoModel: NSObject, Decodable {
    
    let pickUpArr:[PickUpInfoModel]?
    
    private enum CodingKeys: String, CodingKey {
        case pickup
    }
    
    required public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pickUpArr = try container.decode([PickUpInfoModel].self, forKey: .pickup)
    }
}

class PickUpInfoModel: NSObject, Decodable {

    let alias: String?
    let address1: String?
    let city: String?
    let latitude: Double?
    let longitude: Double?
    let active: Bool?
    var distance:String?
    
    var location: CLLocation {
        return CLLocation(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)
    }

    private enum CodingKeys: String, CodingKey {
        case alias
        case address1
        case city
        case latitude
        case longitude
        case active
    }
    
    required public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alias = try container.decode(String.self, forKey: .alias)
        address1 = try container.decode(String.self, forKey: .address1)
        city = try container.decode(String.self, forKey: .city)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        active = try container.decode(Bool.self, forKey: .active)
    }

    func distance(to location: CLLocation) -> CLLocationDistance {
        let distance = location.distance(from: self.location)
        let distanceInKm = distance / 1000
        self.distance = String(format:"%.2f Km",distanceInKm)
        return distance
    }
    
}
