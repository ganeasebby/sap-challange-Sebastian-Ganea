//
//  AppDelegate.swift
//  SAP Challange
//
//  Created by Sebastian Ganea on 18.07.2022.
//

import UIKit

@main
/// Main Application class
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// initialize the application context
    func initializeApplication(){
        /// initialize the UIContent builder. A subclass for the extended functionality can be used
        ContentBuilder.builder = ContentBuilder()
        
        /// initialize the test datasource, for production use the production datasource
        /// this initialization might be better configured. For example from a file.
        DataSourceFactory.shared = DataSourceFactory(factory: TestDataSourceFactory())
//        DataSourceFactory.shared = DataSourceFactory(factory: ProductionDataSource())
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeApplication()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

