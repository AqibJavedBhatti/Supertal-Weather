//
//  CustomForecastViewController.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 20/03/2024.
//

import UIKit

protocol CustomForecastViewModelDelegate {
    func presentError(error: Error)
    func reloadData(forecast: Forecast)
    func presentAlert(alert: UIViewController)
}

class CustomForecastViewModel {
    let screenName: String
    let networkManager: NetworkManager
    var delegate: CustomForecastViewModelDelegate?
    var data: Forecast?
    
    init(screenName: String, networkManager: NetworkManager) {
        self.screenName = screenName
        self.networkManager = networkManager
    }
    
    func validateStringSet(string: String)  -> Bool{
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func fetchData(latitude: String, longitude: String) {
        guard latitude.double != nil , longitude.double != nil else {
            self.makeAlert(title: "Input not valid", message: "Please provide the right values")
            return
        }
        networkManager.getWeather(lat: latitude, long: longitude) { data, error in
            guard let data else {
                let tempError = NSError(domain: "Location not found from client side",
                                        code: 401,
                                        userInfo: nil)
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
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.delegate?.presentAlert(alert: alert)
    }
}


class CustomForecastViewController: UIViewController {

    let viewModel: CustomForecastViewModel
    
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    
    init(viewModel: CustomForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
       
    }
    
    private func setupView() {
        title = viewModel.screenName
        viewModel.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
    }
    
    @IBAction func onClickFetch(_ sender: UIButton) {
        viewModel.fetchData(latitude: latitudeTextField.text ?? "", longitude: longitudeTextField.text ?? "")
    }
}

extension CustomForecastViewController: CustomForecastViewModelDelegate {
    func presentAlert(alert: UIViewController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
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
    
    private func setupData(with viewModel: CustomForecastViewModel) {
        guard let data = viewModel.data else {
            setupEmptyView()
            return
        }
        title = data.name ?? ""
        tempLabel.text = data.main?.celciusTemp
    }
    
    private func setupEmptyView() {
        title = "No data found"
    }
}

extension CustomForecastViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.validateStringSet(string: string)
    }
}
