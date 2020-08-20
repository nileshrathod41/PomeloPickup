//
//  LocationPresenter.swift
//  PomeloPickUp
//
//  Created by Nilesh on 19/08/20.
//  Copyright © 2020 Nilesh. All rights reserved.
//

import Foundation

protocol LocationViewDelegate {
    func displayAllLocation(response: LocationInfoModel)
    func failedToFetchLocation(errorMessage: String)
}

class LocationPresenter {
    
    private let locationService:LocationService!
    private var locationViewDelegate : LocationViewDelegate?
    
    init(locationService:LocationService){
        self.locationService = locationService
    }
    
    func setViewDelegate(trafficLightViewDelegate:LocationViewDelegate?){
        self.locationViewDelegate = trafficLightViewDelegate
    }
    
    func fetchLocations(){
        locationService.getAllLocation { (result) in
            switch result {
            case .success(let response):
                self.locationViewDelegate?.displayAllLocation(response: response)
            case .failure(let error):
                self.locationViewDelegate?.failedToFetchLocation(errorMessage: error)
            }
        }
    }
    
}
