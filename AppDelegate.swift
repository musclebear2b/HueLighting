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
    var bridgesPresent: [(bridgeID: String, IPAddress: String)] = [(String, String)]()
    var defaults = UserDefaults.standard
    var knownBridges: [knownBridge]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        knownBridges = defaults.object(forKey: "bridgesKnown") as? [knownBridge]
        
        
        searchForBridges()
        
        
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


    func searchForBridges() {

        let bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAddressSearch: true)
        bridgeSearch?.startSearch(completionHandler: { (bridgesFound: [AnyHashable : Any]?) in
            
            var searchResult: Bool = false
            if (bridgesFound?.count)! > 0 {
                print(bridgesFound!)
                searchResult =  true
                for (key, value) in bridgesFound! {
                    self.bridgesPresent = [("\(key)", "\(value)") as (bridgeID: String, IPAddress: String)]
                }
                print(self.bridgesPresent.count)
                if (self.bridgesPresent.count > 0) {
                    
                    let knownBridgesPresent = self.compareBridges(knownBridges: self.knownBridges!, foundBridges: self.bridgesPresent)!
                    
                    if ((knownBridgesPresent.count) > 0) {
                        print("\(knownBridgesPresent.count) known bridges found")
                    }  else  {
                        print("No known bridges found")
                    }
                    
                }

                for (key, value) in self.bridgesPresent {
                    print("\(key): \(value)")
                }
            }  else  {
                print("No Bridges Found")
                searchResult =  false
            }
            print("searchResult = \(searchResult)")
        })
        
    }
    
    
    
    func compareBridges(knownBridges: [knownBridge], foundBridges: [(String, String)]) -> [knownBridge]? {
        var returnArray: [knownBridge] = Array()
        for known in knownBridges {
            for found in foundBridges {
                if (known.bridgeID == found.0) {
                    returnArray.append(known)
                }
            }
        }
        return returnArray
    }
    
}

