//
//  HomeViewController.swift
//  PomeloPickUp
//
//  Created by Nilesh on 19/08/20.
//  Copyright © 2020 Nilesh. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tblView: UITableView!
    private let locationPresenter = LocationPresenter(locationService: LocationService())
    var infoArr : [PickUpInfoModel]! = []
    var isLocationApproved:Bool! = false
    let locationManager = CLLocationManager()
    var currentLatLong: CLLocation!
    var selectedCellIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        setDelegate()
        getAllLocation()
    }
    
    func configureInterface() {
        tblView.register(UINib(nibName: "HomeTableCell", bundle: nil), forCellReuseIdentifier: "HomeTableCell")
        tblView.register(UINib(nibName: "NoPickUpCell", bundle: nil), forCellReuseIdentifier: "NoPickUpCell")

        tblView.tableFooterView = UIView.init(frame: .zero)
    }
    
    func setDelegate() {
        locationPresenter.setViewDelegate(trafficLightViewDelegate: self)
    }
    
    func getAllLocation() {
        loader.startAnimating()
        locationPresenter.fetchLocations()
    }

    @IBAction func btnNearByClicked(_ sender: Any) {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else {
            let alertController = UIAlertController(title: NSLocalizedString("Location Service", comment: ""), message: NSLocalizedString("Please enable location service from settings", comment: ""), preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                    UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }

            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
                        self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sortArrayForClosestLocation() {
      self.infoArr.sort(by: { $0.distance(to: currentLatLong) < $1.distance(to: currentLatLong) })
      self.tblView.reloadData()
    }

}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLatLong = manager.location
        self.isLocationApproved = true
        manager.stopUpdatingLocation()
        sortArrayForClosestLocation()
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoArr.count == 0 {
            return 1
        }
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if infoArr.count == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoPickUpCell") as? NoPickUpCell{
               return cell
            }
            
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell") as? HomeTableCell {
            let model = infoArr[indexPath.row]
            cell.setUpCell(model: model, isLocationApproved: isLocationApproved, currentLocation: currentLatLong,cellIndex: indexPath.row,selectedCellIndex: self.selectedCellIndex)
            cell.selectionCallBack = {
                self.selectedCellIndex = indexPath.row
                self.tblView.reloadData()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if infoArr.count == 0 {
            return 60
        }

        return UITableView.automaticDimension
    }

}

extension HomeViewController: LocationViewDelegate {
    
    func displayAllLocation(response: LocationInfoModel) {
        DispatchQueue.main.async {
            if let filteredInfoArr = response.pickUpArr?.filter({$0.active == true}) {
                self.infoArr = filteredInfoArr
            }
            else {
                self.infoArr = []
            }
            
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    func failedToFetchLocation(errorMessage: String) {
        DispatchQueue.main.async {
            self.infoArr = []
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.loader.stopAnimating()
        }
    }
        
}
