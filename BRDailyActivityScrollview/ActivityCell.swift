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
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var iconGeneral: UIImageView?
    @IBOutlet weak var iconReminders: UIImageView? // top left
    @IBOutlet weak var iconStatus: UIImageView? // middle
    @IBOutlet weak var iconMessages: UIImageView? // top right
    @IBOutlet weak var iconRewards: UIImageView? // bottom left
    @IBOutlet weak var iconSpecial: UIImageView? // middle
    @IBOutlet weak var iconKudos: UIImageView? // bottom left
    
    
    @IBOutlet weak var iconSponsor: UIImageView?
    
    @IBOutlet weak var constraintLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.viewBorder.layer.cornerRadius = 10
        self.viewBorder.layer.borderWidth = 4
        self.viewBorder.layer.borderColor = ColorUtil.blueColor().CGColor
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setupWithActivity(activity:Activity) {
        
        // incomplete activities (default)
        self.viewBorder.backgroundColor = UIColor.whiteColor()
        
        self.labelText.text = activity.text
        self.labelText.textColor = ColorUtil.blueColor()

        // icons
        if activity.hasReminders() && self.iconReminders != nil {
            self.iconReminders!.image = UIImage(named: "tile_doctor")
        }
        if activity.hasStatus() && self.iconStatus != nil {
            self.iconReminders!.image = UIImage(named: "tile_clock")
        }
        if activity.hasMessages() && self.iconMessages != nil {
            self.iconReminders!.image = UIImage(named: "tile_speechBubble")
        }
        if activity.hasRewards() && self.iconRewards != nil {
            self.iconReminders!.image = UIImage(named: "tile_star")
        }
        if activity.hasSpecial() && self.iconSpecial != nil {
            self.iconReminders!.image = UIImage(named: "tile_lock")
        }
        if activity.hasKudos() && self.iconKudos != nil {
            self.iconReminders!.image = UIImage(named: "tile_kudos")
        }
    
        if activity.type == ActivityType.Sponsored {
            if self.iconSponsor != nil && activity.sponsor != nil {
                self.iconSponsor!.image = UIImage(named:activity.sponsor!)
            }
            if self.iconGeneral != nil {
                self.iconGeneral!.image = UIImage(named:"tile_syringe")
            }
        }
        
        if activity.type == ActivityType.Challenge {
            if self.iconGeneral != nil {
                self.iconGeneral!.image = UIImage(named:activity.sponsor!)
            }
        }

        
        // completed activities
        if activity.completed == true {
            self.viewBorder.backgroundColor = ColorUtil.darkBlueColor()
            
            self.labelText.textColor = UIColor.whiteColor()
            if activity.type == ActivityType.Weight && activity.weight != nil {
                self.labelText.attributedText = self.attributedStringForWeight(activity.weight!)
            }
        }
        
        if activity.text != nil {
            let string = activity.text! as NSString
            let size:CGSize = string.sizeWithAttributes([NSFontAttributeName: labelText.font])
            
            if activity.type == ActivityType.Sponsored || activity.type == ActivityType.Challenge {
                self.constraintLabelWidth.constant = size.width
            }
            else {
//                self.constraintLabelHeight.constant = size.height + 5
            }
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
