//
//  NormalTableViewCell.swift
//  VPNOn
//
//  Created by Lex on 10/31/15.
//  Copyright © 2015 LexTang.com. All rights reserved.
//

import UIKit

private let kAccessoryWidth: CGFloat = 16

class NormalTableViewCell : UITableViewCell {
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview == nil || accessoryType != .DisclosureIndicator {
            return
        }
        if accessoryView == nil {
            accessoryView = LTTableViewCellDeclosureIndicator()
            accessoryView!.frame = CGRectMake(
                0, 0,
                kAccessoryWidth, kAccessoryWidth
            )
        }
    }
    
}
