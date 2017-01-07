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
    let defaults = UserDefaults.standard
    var knownBridges: [KnownBridge] = []
    var bridgesPresent: [Bridge] = []
    let PHHue: PHHueSDK = PHHueSDK()
    let NotificationManager = PHNotificationManager.default()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if (defaults.value(forKey: "bridgesKnown") == nil) {
            defaults.set(knownBridges, forKey: "bridgesKnown")
        }  else  {
            knownBridges = (defaults.object(forKey: "bridgesKnown") as! [KnownBridge])
        }
        
        searchNetworkForBridges()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        disableHeartbeat()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        enableHeartbeat()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

/*   Older code kept here purely for reference until newer code tested as working
     
     
    func searchForBridges() {

            
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
    

    */
    
    
    
    // Below here start the updated functions
    
func searchNetworkForBridges() {
    let bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAddressSearch: true)
    bridgeSearch?.startSearch(completionHandler: { (bridgesFound: [AnyHashable : Any]?) in
        if ((bridgesFound?.count)! > 0) {
            print("\(bridgesFound?.count) Bridge(s) Found:")
            for bridge in bridgesFound! {
                let id: String = bridge.key as! String
                let ip: String = bridge.value as! String
                let newBridge = Bridge(bridgeID: id, bridgeIPAddress: ip)
                self.bridgesPresent.append(newBridge)
                print(newBridge)
            }
        }  else  {
            print("No Bridges Found!")
        }
    })
    }
    
    func arePresentBridgesKnownBridges(bridgesPresent: [Bridge], bridgesKnown: [KnownBridge]) -> [KnownBridge] {
        var returnArray: [KnownBridge] = []
        for present in bridgesPresent {
            for known in bridgesKnown {
                if present.bridgeID == known.bridgeID {
                    returnArray.append(known)
                }
            }
        }
        return returnArray
    }
    
    
    func pairBridge(bridgeToUse: Bridge) {
        PHHue.setBridgeToUseWithId(bridgeToUse.bridgeID, ipAddress: bridgeToUse.bridgeIPAddress)
        
        
    }
    
    func handlePushlink() {
        NotificationManager?.register(self, with: #selector(authenticationSuccess), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(authenticationFailed), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(noLocalConnection), forNotification: PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(noLocalBridge), forNotification: PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(buttonNotPressed), forNotification: PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION)
        
        self.PHHue.startPushlinkAuthentication()
        
    }
    
    func connectToBridge() {
        NotificationManager?.register(self, with: #selector(localConection), forNotification: LOCAL_CONNECTION_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(noLocalConnection), forNotification: NO_LOCAL_CONNECTION_NOTIFICATION)
        
        NotificationManager?.register(self, with: #selector(notAuthenticated), forNotification: NO_LOCAL_AUTHENTICATION_NOTIFICATION)
    }
    
    func enableHeartbeat() {
        PHHue.setLocalHeartbeatInterval(10.0, for: RESOURCES_ALL)
    }
    
    func disableHeartbeat() {
        PHHue.removeLocalHeartbeat(for: RESOURCES_ALL)
    }
    
    func getBridgeInfo(bridge: KnownBridge) {
        
    }

    func saveNewKnownBridge(bridge: Bridge) {
        
    }

    // pushlink handler functions
    
    func authenticationSuccess() {
        // succesful pushlink.  next, enable a heartbeat to connect to the bridge
        print("Success!")
    }
    
    func authenticationFailed() {
        // inform user that attempt to connect timed out - retry connection ?
        print("Connection attempt timed out.  Please try again")
    }
    
    func noLocalConnection() {
        // Connectivity issues prevented connection, eg connected to the wrong network.  Prompt user to resolve and retry
        print("Please check your network connection and try again, or try connecting to a different bridge")
    }
    
    func noLocalBridge() {
        // Authentication failed because of a coding error - ensure call to PHHue.setBridgeToUse before starting
        print("the person who wrote this code is an idiot! lol!")
    }
    
    func buttonNotPressed(notification: NSNotification) {
        // Authentication is ongoing, but the button has not been pressed yet
        print("Still waiting for someone to press the button!")
        let dict: NSDictionary = notification.userInfo! as NSDictionary
        let progressPercentage = dict.object(forKey: "progressPercentage")
        
        // now display progress to the user
        
        print("Progress: \(progressPercentage)")
        
    }
    
    func localConnection() {
        // if connection succesful, this will be called every hearbeat interval
        // update UI to show connected state and cached data
    }
    
    func notAuthenticated() {
        // This app is not authenticated with the selected bridge.  Start the authentication/pushlink process
    }
    
    
}

