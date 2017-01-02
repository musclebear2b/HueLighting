//
//  AppDelegate.swift
//  HueLighting
//
//  Created by Richard Whent on 02/01/2017.
//  Copyright © 2017 Chunkster.net. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bridges: [AnyHashable: Any]?
    var defaults = UserDefaults.standard
    var knownBridges = Array<Any>()
    var knownBridgesPresent = Array<Any>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let bridgeConfigCache = PHBridgeResourcesReader.readBridgeResourcesCache()
        for bridge in knownBridges {
            knownBridges = defaults.array(forKey: "bridgesKnown")!
            let bridgeConfig = bridgeConfigCache?.bridgeConfiguration
            let bridgeID = bridgeConfig?.bridgeId
            if (compareBridgeIDs(id: bridgeID!)) {
                knownBridgesPresent.append(bridge)
                print("Known bridge present")
            }  else  {
                print("No known bridges present")
            }
            
        }
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func searchForBridges() -> Bool {
        var result: Bool = false

        let bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAddressSearch: true)
        bridgeSearch?.startSearch(completionHandler: { (bridgesFound: [AnyHashable : Any]?) in
            
            if (bridgesFound?.count)! > 0 {
                    self.bridges = bridgesFound
                result =  true
            }  else  {
                print("No Bridges Found")
                result =  false
            }
        })
        return result
    }
    
    func compareBridgeIDs(id: String) -> Bool {
        var result: Bool = false
        
        for _ in knownBridges {
            let bridgeConfig = PHBridgeResourcesReader.readBridgeResourcesCache()
            if (bridgeConfig?.bridgeConfiguration.bridgeId == id) {
                result = true
            }  else  {
                result = false
            }
        }
        return result
    }
    
}

