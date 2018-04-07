//
//  MainViewController.swift
//  OAuth
//
//  Created by Alliston Aleixo on 07/04/2018.
//  Copyright © 2018 Alliston Aleixo. All rights reserved.
//

import UIKit
import WebKit
import Prephirences

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        let dataTypes = Set([WKWebsiteDataTypeCookies,
                             WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage,
                             WKWebsiteDataTypeWebSQLDatabases, WKWebsiteDataTypeIndexedDBDatabases])
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: NSDate.distantPast, completionHandler: {})
        
        KeychainPreferences.sharedInstance["OAuthToken"]         = nil
        KeychainPreferences.sharedInstance["OAuthRefreshToken"]  = nil
        
        AppDelegate.logoutView()
    }
}
