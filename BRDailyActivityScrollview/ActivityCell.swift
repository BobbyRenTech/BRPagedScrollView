//
//  ActivityCell.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/1/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit
import QuartzCore

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }
    
    func setupWithActivity(activity:Activity) {
        self.layer.borderWidth = 4
        self.layer.borderColor = ColorUtil.greenColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        self.labelText.text = activity.text
    }
    
}
