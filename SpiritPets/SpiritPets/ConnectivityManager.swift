//
//  ConnectivityManager.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 12/16/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import WatchConnectivity

protocol ConnectivityManagerProtocol {
    func changeUI()
}

class ConnectivityManager: NSObject, WCSessionDelegate {
    
    var connectivityDelegates = [ConnectivityManagerProtocol]()
    
    static let connectivityManager = ConnectivityManager()
    let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    private override init() {
        super.init()
    }
    
    private var validSession: WCSession? {
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func addDataChangedDelegate<T where T: ConnectivityManagerProtocol, T: Equatable>(delegate: T) {
        connectivityDelegates.append(delegate)
    }
    
    func removeDataChangedDelegate<T where T: ConnectivityManagerProtocol, T: Equatable>(delegate: T) {
        for (index, dataChanged) in connectivityDelegates.enumerated() {
            if let dataChanged = dataChanged as? T, delegate == dataChanged {
                connectivityDelegates.remove(at: index)
                break
            }
        }
    }
    
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        // Update UI
        DispatchQueue.main.async { [weak self] in
            
            let object = applicationContext["updateStatus"] as! [String : Any]
            
            let fed = object["fed"] as! Int

            print("\n\n\n\n\n\n\nvai ma - \(fed)\n\n\n\n\n\n\n\n")
            
            self?.connectivityDelegates.forEach {$0.changeUI()}
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
}
