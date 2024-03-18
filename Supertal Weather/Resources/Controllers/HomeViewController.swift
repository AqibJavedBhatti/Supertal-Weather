//
//  HomeViewController.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 18/03/2024.
//

import UIKit

struct HomeViewModel {
    let screenName: String
    let locationManager: SuperTalLocationManager
    
    init(screenName: String, locationManager: SuperTalLocationManager) {
        self.screenName = screenName
        self.locationManager = locationManager
        getLocationAccessIfRequired()
    }
    
    func getLocationAccessIfRequired() {
        locationManager.getLocationAccess()
        locationManager.actionOnUpdate = { location in
            print("location is", location)
        }
    }
    
    func getLocation() {
        print(locationManager.getLastLocation() as Any)
    }
}




class HomeViewController: UIViewController {

    let viewModel: HomeViewModel!
    
    init(viewModel: HomeViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupView()
    }
    
    private func configureView() {
        navigationController?.navigationBar.isHidden = false
        title = viewModel.screenName
    }
    
    private func setupView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.viewModel.getLocation()
        }
    }
}
