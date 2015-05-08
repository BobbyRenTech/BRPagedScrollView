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
    @IBOutlet weak var progressView: UIProgressView?
    
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

        // reset icons in case of reuse
        self.iconReminders?.image = nil
        self.iconStatus?.image = nil
        self.iconMessages?.image = nil
        self.iconRewards?.image = nil
        self.iconSpecial?.image = nil
        self.iconKudos?.image = nil

        // icons
        if activity.hasReminders() && self.iconReminders != nil {
            self.iconReminders!.image = UIImage(named: "tile_doctor")
        }
        if activity.hasStatus() && self.iconStatus != nil {
            self.iconStatus!.image = UIImage(named: "tile_clock")
        }
        if activity.hasMessages() && self.iconMessages != nil {
            self.iconMessages!.image = UIImage(named: "tile_speechBubble")
        }
        if activity.hasRewards() && self.iconRewards != nil {
            self.iconRewards!.image = UIImage(named: "tile_star")
        }
        if activity.hasSpecial() && self.iconSpecial != nil {
            self.iconSpecial!.image = UIImage(named: "tile_lock")
        }
        if activity.hasKudos() && self.iconKudos != nil {
            self.iconKudos!.image = UIImage(named: "tile_kudos")
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
            if self.progressView != nil {
                self.progressView!.hidden = false
            }
            if self.iconGeneral != nil {
                self.iconGeneral!.image = UIImage(named:activity.sponsor!)
            }
            if activity.text != nil {
                self.labelText.attributedText = self.attributedStringForChallenge(activity.text!)
            }
        }

        // completed activities
        if activity.completed == true {
            self.viewBorder.backgroundColor = ColorUtil.darkBlueColor()
            
            self.labelText.textColor = UIColor.whiteColor()
            if activity.type == ActivityType.Weight && activity.weight != nil {
                self.labelText.attributedText = self.attributedStringForWeight(activity.weight!)
            }
            if activity.type == ActivityType.Feet && activity.feetStatus != nil {
                self.labelText.attributedText = self.attributedStringForFeetStatus(activity.feetStatus!)
            }
            /*
            self.iconReminders?.hidden = true
            self.iconMessages?.hidden = true
            self.iconStatus?.hidden = true
            */
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
        var boldString = "\(Int(weight)) lbs"
        var baseString = "Today's weight\n\(boldString) lbs"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: ColorUtil.blueColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(boldString)
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(25), NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
    
    func attributedStringForChallenge(baseString:String) -> NSAttributedString? {
        var boldString = "Walk 10 miles in 7 days"
        var baseString = "Whole Foods Challenge\nWalk 10 miles in 7 days"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: ColorUtil.darkGreenColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(boldString)
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
    
    func attributedStringForFeetStatus(status:String) -> NSAttributedString? {
        var boldString = status
        var baseString = "Feet are " + status + " today"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: ColorUtil.blueColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(boldString)
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(25), NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
}
