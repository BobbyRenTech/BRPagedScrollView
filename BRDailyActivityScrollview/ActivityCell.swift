//
//  ActivityCell.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/1/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit
import QuartzCore

let SHOW_ICONS = true

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
        
        // incomplete activities (default)
        self.layer.borderColor = ColorUtil.blueColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        self.labelText.text = activity.text
        self.labelText.textColor = ColorUtil.blueColor()

        if SHOW_ICONS {
            if activity.iconName != nil {
                self.icon.image = UIImage(named:activity.iconName!)
            }
        }
        
        if activity.type == ActivityType.Sponsored {
            if self.iconSponsor != nil && activity.iconName != nil {
                // sponsor icon should be company icon - TODO use activity.iconSponsorName
                self.iconSponsor!.image = UIImage(named:activity.iconName!)
            }
            if activity.iconName != nil {
                self.icon.image = UIImage(named:activity.iconName!)
            }
        }
        
        // completed activities
        if activity.completed == true {
            self.layer.borderColor = ColorUtil.greenColor().CGColor
            self.backgroundColor = ColorUtil.darkBlueColor()
            
            if SHOW_ICONS {
                if activity.iconNameComplete != nil {
                    self.icon.image = UIImage(named:activity.iconNameComplete!)
                }
            }
            
            self.labelText.textColor = UIColor.whiteColor()
            if activity.type == ActivityType.Weight && activity.weight != nil {
                self.labelText.attributedText = self.attributedStringForWeight(activity.weight!)
            }
        }
        
        if activity.text != nil {
            let string = activity.text! as NSString
            let size:CGSize = string.sizeWithAttributes([NSFontAttributeName: labelText.font])
            self.constraintLabelHeight.constant = size.height + 5
        }

    }

    func attributedStringForWeight(weight:CGFloat) -> NSAttributedString? {
        var weightString = "\(Int(weight)) lbs"
        var baseString = "Today's weight\n\(weightString)"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: ColorUtil.blueColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(weightString)
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(25), NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
}
