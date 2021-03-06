//
//  MultipeerManager.swift
//  TicTacToe
//
//  Created by Renan Trévia on 11/8/16.
//  Copyright © 2016 Pedro Albuquerque. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MultipeerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(fromPeer: MCPeerID, withData: Data)
    
    func connectedWithPeer(peerID: MCPeerID, imageName: String)
}

class MultipeerManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var session: MCSession!
    var localPeer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeer: [MCPeerID] = [MCPeerID]()
    var opponentsImagesName = [String]()
    var invitationHandler: ((Bool, MCSession?) -> Void)!
    
    var delegate: MultipeerDelegate?
    
    override init() {
        super.init()
        
        localPeer = MCPeerID(displayName: UIDevice.current.name)
        
        //session = MCSession(peer: peer)
        session = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: localPeer, serviceType: "spirit-pets")
        browser.delegate = self
        
        //advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: ["imageName": PetManager.sharedInstance.petChoosed.frontImageName], serviceType: "spirit-pets")
        //advertiser.delegate = self
    }
    
    func startAdvertise(){
        advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: ["imageName": PetManager.sharedInstance.petChoosed.frontImageName], serviceType: "spirit-pets")
        advertiser.delegate = self
    }
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID)  -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        //        var error: NSError?
        
        do {
            try session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
            
        } catch {
//            print(error)
//            print("PAU NO SEND DATA!!!!!")
            return false
        }
        
        return true
    }
    
    func sendDataInt(dictionaryWithData dictionary: Dictionary<String, [Int]>, toPeer targetPeer: MCPeerID)  -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        //        var error: NSError?
        
        do {
            try session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
        } catch {
//            print("PAU NO SEND DATA!!!!!")
            return false
        }
        
        return true
    }
    
    /// BROWSER DELEGATE
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if let infoRecived = info?["imageName"]{
            opponentsImagesName.append( infoRecived )
            foundPeer.append(peerID)
            
            delegate?.foundPeer()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (index, aPeer) in foundPeer.enumerated() {
            if aPeer == peerID {
                foundPeer.remove(at: index)
                break
            }
        }
        
        delegate?.lostPeer()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        print(error.localizedDescription)
    }
    
    /// SESSION DELEGATE
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let dictionary: [String: Any] = ["data": data , "fromPeer": peerID]
        //ATENÇÃO, ISSO PODE DAR PAU VVVVVVV
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary, userInfo: dictionary)
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
//            print("Connected to session: \(session)")
            if peerID != localPeer{
                delegate?.connectedWithPeer(peerID: peerID, imageName: opponentsImagesName[foundPeer.index(of: peerID)!])
            }
        case MCSessionState.connecting: break
//            print("Connecting to session: \(session)")
        default: break
//            print("Did not connect to session: \(session)")
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) { }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    
    /// ADVERTISER DELEGATE
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        delegate?.invitationWasReceived(fromPeer: peerID, withData: context!)
    }
}
