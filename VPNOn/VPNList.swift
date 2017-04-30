//
//  VPNTableViewController.swift
//  VPN On
//
//  Created by Lex Tang on 12/4/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//

import UIKit
import CoreData
import NetworkExtension
import VPNOnKit

let kSelectionDidChange = "SelectionDidChange"
private let kVPNIDKey = "VPNID"

let kVPNConnectionSection = 0
let kVPNOnDemandSection = 1
let kVPNListSection = 2
let kVPNAddSection = 3

final class VPNList: UITableViewController, SimplePingDelegate, VPNDomainsDelegate {
    
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    @IBOutlet weak var restartPingButton: UIBarButtonItem!
    
    var vpns: [VPN]?
    var activatedVPNID: String?
    var connectionStatus = NSLocalizedString(
        "Not Connected",
        comment: "Connection Status"
    )
    var connectionOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = LTViewControllerBackground()
        
        // MARK: - Notifications
        let NC = NSNotificationCenter.defaultCenter()
        
        [
            kVPNDidUpdate,
            kVPNDidCreate,
            kVPNDidRemove,
            kVPNDidDuplicate
            ].forEach {
                NC.addObserver(
                    self,
                    selector: "didEditVPN:",
                    name: $0,
                    object: nil)
        }
        
        NC.addObserver(
            self,
            selector: "pingDidUpdate:",
            name: kPingDidUpdate,
            object: nil)
        
        NC.addObserver(
            self,
            selector: "pingDidComplete:",
            name: kPingDidComplete,
            object: nil)
        
        NC.addObserver(
            self,
            selector: "VPNDidChangeStatus:",
            name: NEVPNStatusDidChangeNotification,
            object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadVPNs()
    }
    
    func reloadVPNs() {
        vpns = VPNDataManager.sharedManager.allVPN()
        
        if let selectedID = VPNDataManager.sharedManager.selectedVPNID {
            if selectedID != activatedVPNID {
                activatedVPNID = selectedID.URIRepresentation().absoluteString
                tableView?.reloadData()
            }
        }
    }
    
    // MARK: - VPNDomainsDelegate
    
    func didTapSaveDomainsWithText(text: String) {
        updateOnDemandCell()
    }
    
}
