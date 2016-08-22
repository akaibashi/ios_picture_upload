//
//  AppDelegate.swift
//  ios_picture_upload
//
//  Created by 赤井橋 健2 on 2016/08/18.
//  Copyright © 2016年 ken akaibashi. All rights reserved.
//

import UIKit
import CoreData
import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .APNortheast1,
                                                                identityPoolId: "ap-northeast-1:9e542f04-cb0d-43da-b572-a39c3f5c7290")
        let configuration = AWSServiceConfiguration(region: .APNortheast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        return true
        
    }
    
    
    
    
   
}