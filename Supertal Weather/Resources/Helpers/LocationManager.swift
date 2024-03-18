//
//  LocationManager.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 18/03/2024.
//

import Foundation
import CoreLocation


class SuperTalLocationManager: NSObject {
    let manager: CLLocationManager
    var actionOnUpdate: ((CLLocation)->Void)?
    private var lastLocation: CLLocation? {
        get {
            guard let latitude = UserDefaults.standard.string(forKey: "LastLatitude"),
                  let longitude = UserDefaults.standard.string(forKey: "LastLongitude")  else {
                return nil
            }
            return CLLocation(latitude: .init(latitude) ?? 0.0 ,
                              longitude: .init(longitude) ?? 0.0)
        } set {
            let latitude = "\(newValue?.coordinate.latitude ?? 0)"
            let longitude = "\(newValue?.coordinate.longitude ?? 0)"
            UserDefaults.standard.setValue(latitude, forKey: "LastLatitude")
            UserDefaults.standard.setValue(longitude, forKey: "LastLongitude")
        }
    }
    
    override init() {
        manager = CLLocationManager()
    }
    
    public func getLocationAccess() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if CLLocationManager.locationServicesEnabled() {
                manager.delegate = self
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
            }
        }
    }
    
    public func getLastLocation() -> CLLocation? {
        return lastLocation
    }
}

extension SuperTalLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("not authorized")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            print("not determined")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        lastLocation = location
        actionOnUpdate?(location)
    }
}
