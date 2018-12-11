//
//  ViewController.swift
//  TimeTester
//
//  Created by Abraham VG on 11/12/18.
//  Copyright © 2018 Wis. All rights reserved.
//

import UIKit
import TrueTime

class ViewController: UIViewController {
    
let client = TrueTimeClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.start()
        let now = client.referenceTime?.now()
        print("Now = \(String(describing: now))")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        client.fetchIfNeeded { result in
            switch result {
            case let .success(referenceTime):
                let now = referenceTime.now()
                
                let UTCDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(identifier:"GMT")
                let currentGMT = formatter.string(from: UTCDate)
                
                print("currentGMT = \(currentGMT)")
                let newDate = formatter.string(from: now)
                print("Now = \(String(describing: newDate))")
                if currentGMT != newDate {
                    self.goToSettings()
                }
                
                
                
                
            case let .failure(error):
                print("Error! \(error)")
            }
        }
    }
    
    
    //MARK:
    func goToSettings() {
        let alertController = UIAlertController (title: "The Time is not correct", message: "Go to Settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let profileUrl = URL(string: "App-Prefs:root=General&path=Date&Time") else {
                print("Failes to call general")
            return
        }
        
        if UIApplication.shared.canOpenURL(profileUrl) {
            
            UIApplication.shared.open(profileUrl, completionHandler: { (success) in
                
                print(" Profile Settings opened: \(success)")
                
            })
        }
            
//            if let url = URL(string:"App-Prefs:root=Wallpaper") {
//                if UIApplication.shared.canOpenURL(url) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    } else {
//                        UIApplication.shared.openURL(url)
//                    }
//                }
//            }
            
//            if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
//                // UIApplication.shared.openURL(appSettings as URL)
//                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
//            }
            
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            }
        }
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }


}

