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
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconSponsor: UIImageView?
    
    @IBOutlet weak var constraintLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }
    
    func setupWithActivity(activity:Activity) {
        self.layer.borderWidth = 4
        self.layer.borderColor = ColorUtil.greenColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        self.labelText.text = activity.text
        self.labelText.textColor = ColorUtil.blueColor()
        
        if activity.icon != nil {
            self.icon.image = activity.icon
        }
        if activity.type == ActivityType.Sponsored && self.iconSponsor != nil {
            // sponsor icon should be company icon
//            self.iconSponsor!.image = activity
        }
        
        // completed activities
        if activity.completed == true {
            self.backgroundColor = ColorUtil.darkBlueColor()
            self.labelText.textColor = UIColor.whiteColor()
            self.labelText.text = "Today's weight\n\(activity.weight!)"
            self.icon.image = activity.icon
        }
        
        if activity.text != nil {
            let string = activity.text! as NSString
            let size:CGSize = string.sizeWithAttributes([NSFontAttributeName: labelText.font])
            self.constraintLabelHeight.constant = size.height + 5
        }

    }
    
}
