
//  GPSservice.swift
//  MapDemo
//
//  Created by Higher Visibility on 28/01/2017.
//  Copyright © 2017 Higher Visibility. All rights reserved.
//

import Foundation
import CoreLocation


class GPSservice:NSObject,CLLocationManagerDelegate {

static var shareInstance = GPSservice()
    
    var time = Date()
    
    let locationManager = CLLocationManager()
    
    func startGPS_services(){
        
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        
            if CLLocationManager.locationServicesEnabled() {
                
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                
                if #available(iOS 9.0, *) {
                    
                    self.locationManager.pausesLocationUpdatesAutomatically = false 
                    self.locationManager.allowsBackgroundLocationUpdates = true
                    
                }
                self.locationManager.startUpdatingLocation()
            }
        }
    
    func stopGPS_Services(){
    
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last?.coordinate{
        
            self.time = locations.last!.timestamp
          //  UserLoc.sharedInstance.userLocation = location
            print("latitude:=== \(location.latitude) longitude:== \(location.longitude) Accuracy:==\(String(describing: manager.location!.horizontalAccuracy)), Time\(self.time)")
            
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let loc =  manager.location?.coordinate{
        
       // UserLoc.sharedInstance.userLocation = loc
        
        }
        print("didFailWithError:------------------------\(error)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
                print("Authorization status changed to \(status.rawValue)")
        
                switch status {
        
                case CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse:
        
                   // FlagVariables.gps_status = 1
                    GPSservice.shareInstance.locationManager.startUpdatingLocation()
        
                default:
        
                    GPSservice.shareInstance.locationManager.stopUpdatingLocation()
                   // NotificationCenter.default.post(NSNotification.Name(rawValue: //MyUserDefaults.gpsNotification),object: nil)
                   // FlagVariables.gps_status = 2
                    
                }

        
    }
    

    func getPlacePositionAndDetails(place:String,completion:@escaping (_ place:CLPlacemark,_ result:Bool)->()){
        
        CLGeocoder().geocodeAddressString(place,completionHandler:{placemarks,error -> () in
            
            if error == nil{
            
                    if placemarks!.count > 0 {
                        
                        if let place:[CLPlacemark] = placemarks{
                            
                          let clplace = place[0]
                         
                          completion(clplace, true)
                        }
                    }
            }
        })
    }
    
    func checkGPS_Service() -> Bool{
        
        var value = false
        if CLLocationManager.locationServicesEnabled() == true
        {
         value = true
        }
        else
        {
        value = false
        }
        return value
    }

}








