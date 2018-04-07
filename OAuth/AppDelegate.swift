//
//  AppDelegate.swift
//  OAuth
//
//  Created by Alliston Aleixo on 07/04/2018.
//  Copyright © 2018 Alliston Aleixo. All rights reserved.
//

import UIKit
import OAuthSwift
import Prephirences
import Alamofire
import OAuthSwiftAlamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    private static let mainViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
    private static let loginViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")

    // MARK: - Application Methods
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let oauthToken          = KeychainPreferences.sharedInstance.string(forKey: "OAuthToken")
        let oauthRefreshToken   = KeychainPreferences.sharedInstance.string(forKey: "OAuthRefreshToken")
        
        if (oauthToken != nil && oauthRefreshToken != nil) {
            self.window?.rootViewController = AppDelegate.mainViewController;
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        applicationHandle(url: url)
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        applicationHandle(url: url)
        return true
    }
    
    // MARK: - Static Methods
    static func getAppProperty(forKey key: String) -> String {
        let dictionary: NSDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
        return dictionary[key] as! String
    }
    
    // MARK: - Private Methods
    private func applicationHandle(url: URL) {
        if (url.host == "oauth-callback" ||
            url.host == "oauth-github-callback") {
            OAuthSwift.handle(url: url)
        } else {
            OAuthSwift.handle(url: url)
        }
    }
    
    static func authorize(viewController: UIViewController) {
        CustomOAuth2.sharedInstance.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: CustomOAuth2.sharedInstance)
        
        let _ = CustomOAuth2.sharedInstance.authorize(
            withCallbackURL: URL(string: "<URL_SCHEME>://oauth-callback")!,
            scope: "<API_NAME>",
            state: generateState(withLength: 20),
            success: { credential, response, parameters in
                debugPrint("Authenticated")
                
                KeychainPreferences.sharedInstance["OAuthToken"]         = credential.oauthToken
                KeychainPreferences.sharedInstance["OAuthRefreshToken"]  = credential.oauthRefreshToken
                
                debugPrint(credential.oauthToken)
                debugPrint(credential.oauthRefreshToken)
                
                SessionManager.default.adapter = OAuthSwift2RequestAdapter(CustomOAuth2.sharedInstance)
                SessionManager.default.retrier = OAuthSwift2RequestAdapter(CustomOAuth2.sharedInstance)
                
                viewController.show(AppDelegate.mainViewController, sender: nil)
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")
            }
        )
    }
    
    static func authorizeGitHub(viewController: UIViewController) {
        GitHubOAuth2.sharedInstance.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: GitHubOAuth2.sharedInstance)
        
        let _ = GitHubOAuth2.sharedInstance.authorize(
            withCallbackURL: URL(string: "<URL_SCHEME>://oauth-github-callback")!,
            scope: "<API_NAME>",
            state: generateState(withLength: 20),
            success: { credential, response, parameters in
                debugPrint("Authenticated")
                
                KeychainPreferences.sharedInstance["OAuthToken"]         = credential.oauthToken
                KeychainPreferences.sharedInstance["OAuthRefreshToken"]  = credential.oauthRefreshToken
                
                debugPrint(credential.oauthToken)
                debugPrint(credential.oauthRefreshToken)
                
                SessionManager.default.adapter = OAuthSwift2RequestAdapter(CustomOAuth2.sharedInstance)
                SessionManager.default.retrier = OAuthSwift2RequestAdapter(CustomOAuth2.sharedInstance)
                
                viewController.show(AppDelegate.mainViewController, sender: nil)
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")
            }
        )
    }
    
    static func logoutView() {
        UIApplication.shared.delegate!.window??.rootViewController = AppDelegate.loginViewController;
    }
}
