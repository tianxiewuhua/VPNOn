//
//  VPNCell.swift
//  VPNOn
//
//  Created by Lex Tang on 3/5/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import VPNOnKit
import NetworkExtension
import QuartzCore

private let ConnectedColor = UIColor(red: 0, green: 0.75, blue: 1, alpha: 1)

final class VPNCell: UICollectionViewCell {
    
    @IBOutlet weak var switchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var latencyLabel: UILabel!
    
    override func didMoveToSuperview() {
        switchButton.onTintColor = ConnectedColor
        switchButton.tintColor = UIColor(white: 1.0, alpha: 0.2)
        switchButton.thumbTintColor = UIColor.whiteColor()
        latencyLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 12)
    }
    
    var current: Bool = false
    
    var latency: Int = -1 {
        didSet {
            latencyLabel.hidden = !flagImageView.hidden
            if latency == -1 {
                latencyLabel.text = ""
            } else {
                latencyLabel.text = "\(latency)"
            }
            switchButton.tintColor = colorOfLatency
            latencyLabel.textColor = colorOfLatency

            if status == .Connected {
                titleLabel.textColor = ConnectedColor
            } else {
                titleLabel.textColor = colorOfLatency
            }
        }
    }
    
    var colorOfLatency: UIColor {
        var latencyColor = UIColor(red: 0.5, green: 0.8, blue: 0.19, alpha: 1)
        
        if latency > 500 {
            latencyColor = UIColor(red: 1, green: 0.11, blue: 0.34, alpha: 1)
        } else if latency > 200 {
            latencyColor = UIColor(red: 0.8184, green: 0.5066, blue: 0.0, alpha: 1)
        } else if latency == -1 {
            latencyColor = UIColor(white: 0.8, alpha: 0.4)
        }
        
        return latencyColor
    }
    
    var status: NEVPNStatus = .Disconnected {
        didSet {
            animateFlagAndSwitchByStatus()
        }
    }
    
    func configureWithVPN(vpn: VPN, selected: Bool = false) {
        current = selected
        titleLabel.text = vpn.title
        switchIndicator.stopAnimating()
        
        if VPNManager.sharedManager.displayFlags {
            switchButton.hidden = true
            if let countryCode = vpn.countryCode {
                flagImageView.image = UIImage(
                    flagImageWithCountryCode: countryCode.uppercaseString
                )
            } else {
                flagImageView.image = UIImage(flagImageForSpecialFlag: .World)
            }
            flagImageView.hidden = false
            if VPNManager.sharedManager.status == .Connected
                || VPNManager.sharedManager.status == .Connecting
            {
                flagImageView.alpha = current ? 1.0 : 0.4
            } else {
                flagImageView.alpha = 1.0
            }
        } else {
            flagImageView.image = nil
            flagImageView.hidden = true
            switchButton.hidden = false
        }
    }
    
    func animateFlagAndSwitchByStatus() {
        flagImageView.layer.removeAllAnimations()
        latencyLabel.alpha = 1.0
        
        if !current {
            switchButton.setOn(false, animated: false)
        } else if status == .Connecting {
            latencyLabel.alpha = 0
            let bounce = CABasicAnimation(keyPath: "position")
            let endPoint = CGPointMake(flagImageView.layer.position.x, flagImageView.layer.position.y - 6)
            let currentPoint = flagImageView.layer.position
            bounce.duration = 0.3
            bounce.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            bounce.repeatCount = HUGE
            bounce.autoreverses = true
            bounce.fromValue = NSValue(CGPoint: currentPoint)
            bounce.toValue = NSValue(CGPoint: endPoint)
            flagImageView.layer.addAnimation(bounce, forKey: "bounce")
            if !switchButton.hidden {
                switchIndicator.hidden = false
                switchIndicator.startAnimating()
                switchButton.setOn(true, animated: true)
            }
        } else {
            switchIndicator.stopAnimating()
            switchIndicator.hidden = true
            if status == .Connected {
                latencyLabel.alpha = 0
                switchButton.setOn(true, animated: false)
            } else {
                latencyLabel.alpha = 1
                switchButton.setOn(false, animated: false)
            }
        }
    }
}
