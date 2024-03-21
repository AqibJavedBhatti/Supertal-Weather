//
//  HomeViewController.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 18/03/2024.
//

import UIKit
import CoreLocation

protocol HomeViewModelDelegate {
    func locationFetched()
    func presentError(error: Error)
    func reloadData(forecast: Forecast)
    func openCustomForecast(controller: UIViewController)
}

class HomeViewModel {
    let screenName: String
    let locationManager: SuperTalLocationManager
    let networkManager: NetworkManager
    var location: CLLocation?
    var delegate: HomeViewModelDelegate?
    var data: Forecast?
    var alreadyUpdated: Bool = false
    
    init(screenName: String, locationManager: SuperTalLocationManager, networkManager: NetworkManager) {
        self.screenName = screenName
        self.locationManager = locationManager
        self.networkManager = networkManager
    }
    
    deinit {
        delegate = nil
    }
    
    func getLocationAccessIfRequired() {
        locationManager.getLocationAccess()
        locationManager.actionOnUpdate = { location in
            guard !self.alreadyUpdated else {return}
            self.alreadyUpdated = true
            self.location = location
            DispatchQueue.global().async {
                self.delegate?.locationFetched()
            }
        }
    }
    
    func getWeather() {
        let tempError = NSError(domain: "Location not found from client side",
                                code: 401,
                                userInfo: nil)
        guard let location else {
            delegate?.presentError(error: tempError)
            return }
        networkManager.getWeather(lat: "\(location.coordinate.latitude)",
                                  long: "\(location.coordinate.longitude)") { data, error in
            guard let data else {
                self.delegate?.presentError(error: error ?? tempError)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let forecast = try jsonDecoder.decode(Forecast.self, from: data)
                self.data = forecast
                self.delegate?.reloadData(forecast: forecast)
            } catch {
                self.delegate?.presentError(error: error)
            }
            
        }
    }
    
    func openCustomForecastScreen() {
        let vc = CustomForecastViewController(viewModel: .init(screenName: "Weather using Lat long", 
                                                               networkManager: networkManager))
        delegate?.openCustomForecast(controller: vc)
    }
}

class HomeViewController: UIViewController {

    let viewModel: HomeViewModel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var sunriselabel: UILabel!
    @IBOutlet weak var sunsetlabel: UILabel!
    @IBOutlet weak var humiditylabel: UILabel!
    @IBOutlet weak var cloudylabel: UILabel!
    @IBOutlet weak var windlabel: UILabel!
    @IBOutlet weak var conditionlabel: UILabel!
    @IBOutlet weak var citylabel: UILabel!
    @IBOutlet weak var timezonelabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyDescription: UILabel!
    
    let spinner = UIActivityIndicatorView(style: .large)

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
    }
    
    private func configureView() {
        viewModel.delegate = self
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "refresh")?.withTintColor(.black), style: .done, target: self, action: #selector(onTapRefresh))
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black), style: .done, target: self, action: #selector(onTapSearch))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        title = "Fetching Location..."
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
        viewModel.getLocationAccessIfRequired()
        setupData(with: viewModel)
    }
    
    private func setupData(with viewModel: HomeViewModel) {
        guard let data = viewModel.data else {
            setupEmptyView()
            return
        }
        title = data.name ?? ""
        tempLabel.text = data.main?.celciusTemp
        emptyView.isHidden = true
        
        sunriselabel.text    = data.sys?.computedSunrise
        sunsetlabel.text     = data.sys?.computedSunset
        humiditylabel.text   = "\(data.main?.humidity ?? 0)%"
        cloudylabel.text     = "\(data.clouds?.all ?? 0)%"
        windlabel.text       = "\(data.wind?.computedSpeed ?? "") km/h at \(data.wind?.deg ?? 0)°"
        conditionlabel.text  = "\(data.computedWeather?.description ?? "")"
        citylabel.text       = data.name
        timezonelabel.text   = "GMT \(Float(data.timezone ?? 1) / 3600)"
        
        spinner.removeFromSuperview()
    }
    
    private func setupEmptyView() {
        title = "No data, Try refreshing ->"
        emptyView.isHidden = true
        sunriselabel.text    = "Loading..."
        sunsetlabel.text     = "Loading..."
        humiditylabel.text   = "Loading..."
        cloudylabel.text     = "Loading..."
        windlabel.text       = "Loading..."
        conditionlabel.text  = "Loading..."
        citylabel.text       = "Loading..."
        timezonelabel.text   = "Loading..."
        tempLabel.text = "--"
    }
    
    private func errorView() {
        
    }
    
    @objc func onTapRefresh() {
        guard spinner.superview == nil else {return}
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
        viewModel.getWeather()
    }
    
    @objc func onTapSearch() {
        viewModel.openCustomForecastScreen()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func openCustomForecast(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Due to some technical Reasons we are unable to load weater data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func reloadData(forecast: Forecast) {
        DispatchQueue.main.async {
            self.setupData(with: self.viewModel)
        }
    }
    
    func locationFetched() {
        viewModel.getWeather()
    }
}
