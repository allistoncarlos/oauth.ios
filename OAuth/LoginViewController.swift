//
//  LoginViewController.swift
//  OAuth
//
//  Created by Alliston Aleixo on 07/04/2018.
//  Copyright © 2018 Alliston Aleixo. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTouched(_ sender: Any) {
        AppDelegate.authorize(viewController: self)
    }
}
