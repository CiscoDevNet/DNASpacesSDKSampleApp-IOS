//
//  UsageTableViewCell.swift
//  OpenRoaming
//
//  Created by rajesh36 on 04/12/19.
//  Copyright © 2019 rajesh36. All rights reserved.
//

import UIKit

class UsageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ssidLabel: UILabel!
    @IBOutlet weak var deviceUsedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
