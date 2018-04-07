//
//  CustomOAuth2.swift
//  OAuth
//
//  Created by Alliston Aleixo on 07/04/2018.
//  Copyright © 2018 Alliston Aleixo. All rights reserved.
//

import Foundation
import Prephirences
import OAuthSwift

class CustomOAuth2: OAuth2Swift {
    static var sharedInstance = CustomOAuth2(
        consumerKey:    "<CONSUMER_KEY>",
        consumerSecret: "<CONSUMER_SECRET>",
        authorizeUrl: "\(AppDelegate.getAppProperty(forKey: "BaseURL"))/connect/authorize",
        accessTokenUrl: "\(AppDelegate.getAppProperty(forKey: "BaseURL"))/connect/token",
        responseType: "code"
    )
    
    override func renewAccessToken(withRefreshToken refreshToken: String, parameters: OAuthSwift.Parameters?, headers: OAuthSwift.Headers?, success: @escaping OAuthSwift.TokenSuccessHandler, failure: OAuthSwift.FailureHandler?) -> OAuthSwiftRequestHandle? {
        
        print("reset access_token")
        client.credential.oauthToken = ""
        client.credential.oauthTokenExpiresAt = nil
        
        return super.renewAccessToken(withRefreshToken: client.credential.oauthRefreshToken, parameters: parameters, headers: headers, success: { (credential, response, successParameters) in
            KeychainPreferences.sharedInstance["OAuthToken"]         = credential.oauthToken
            KeychainPreferences.sharedInstance["OAuthRefreshToken"]  = credential.oauthRefreshToken
            
            success(credential, response, successParameters)
        }, failure: failure)
    }
}
