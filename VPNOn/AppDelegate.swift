//
//  AppDelegate.swift
//  VPNOn
//
//  Created by Lex Tang on 12/5/14.
//  Copyright (c) 2014 LexTang.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate:
    UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool {
            if let splitViewController = window?.rootViewController
                as? UISplitViewController {
                    splitViewController.delegate = self
                    splitViewController.preferredDisplayMode = .AllVisible
            }
            
            LTThemeManager.sharedManager.activateTheme()
            
            return true
    }
    
    // MARK: - Split view
    
    func splitViewController(
        splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController:UIViewController,
        ontoPrimaryViewController primaryViewController:UIViewController
        ) -> Bool {
            if let secondaryAsNavController = secondaryViewController
                as? UINavigationController {
                    if let _ = secondaryAsNavController.topViewController {
                        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                        return true
                    }
            }
            return false
    }
}

