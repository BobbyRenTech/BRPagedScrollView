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

protocol ActivityCellDelegate {
    func didSelectActivityTile(cell:ActivityCell)
}

class ActivityCell: UICollectionViewCell, UIGestureRecognizerDelegate {
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
    
    weak var activity:Activity?
    var delegate:ActivityCellDelegate?
    
    var isPressing: Bool = false
    
    override func awakeFromNib() {
        self.viewBorder.layer.cornerRadius = 10
        self.viewBorder.layer.borderWidth = 4
        self.viewBorder.layer.borderColor = ColorUtil.blueColor().CGColor
        self.backgroundColor = UIColor.clearColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleGesture:")
        tap.delegate = self
        self.addGestureRecognizer(tap)
        let press: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleGesture:")
        press.delegate = self
        press.minimumPressDuration = 0.25
        self.addGestureRecognizer(press)
    }
    
    func setupWithActivity(activity:Activity) {
        self.activity = activity
        
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
        if activity.hasReminders() {
            self.iconReminders?.image = UIImage(named: "tile_doctor")
        }
        if activity.hasStatus() {
            self.iconStatus?.image = UIImage(named: "tile_clock")
        }
        if activity.hasMessages() {
            self.iconMessages?.image = UIImage(named: "tile_speechBubble")
        }
        if activity.hasRewards() {
            self.iconRewards?.image = UIImage(named: "tile_star")
        }
        if activity.hasSpecial() {
            // no special status tiles
        }
        if activity.hasKudos() {
            self.iconKudos?.image = UIImage(named: "tile_kudos")
        }
        if activity.isLocked() {
            self.iconStatus?.image = UIImage(named: "tile_lock")
            
            // use gray content
            /*
            self.labelText.textColor = UIColor.lightGrayColor()
            self.viewBorder.layer.borderColor = UIColor.lightGrayColor().CGColor
            */
            
            // use alpha
            /*
            self.viewBorder.alpha = 0.5
            */
            
            // use gray bg
            self.labelText.alpha = 0.5
            self.viewBorder.backgroundColor = UIColor(white: 0.9, alpha: 1)
        }
    
        if activity.type == ActivityType.Sponsored {
            if activity.sponsor != nil {
                self.iconSponsor?.image = UIImage(named:activity.sponsor!)
            }
            self.iconGeneral?.image = UIImage(named:"tile_syringe")
        }
        
        if activity.type == ActivityType.Challenge {
            if self.progressView != nil {
                self.progressView!.hidden = false
            }
            self.iconGeneral?.image = UIImage(named:activity.sponsor!)
            
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
        var baseString = "Today's weight\n\(boldString)"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var font:UIFont = UIFont(name: "Helvetica-Light", size: 14)!
        var attrs = [NSFontAttributeName : font, NSForegroundColorAttributeName: ColorUtil.blueColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(boldString)
        font = UIFont(name:"Helvetica", size:36)!
        var otherAttrs = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
    
    func attributedStringForChallenge(baseString:String) -> NSAttributedString? {
        var boldString = "Walk 10 miles in 7 days"
        var baseString = "Whole Foods Challenge\nWalk 10 miles in 7 days"
        
        var attributedString = NSMutableAttributedString(string: baseString)
        var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: ColorUtil.darkGreenColor()]
        var result = NSMutableAttributedString(string: baseString, attributes: attrs) as NSMutableAttributedString
        
        var targetString = baseString as NSString
        var range = targetString.rangeOfString(boldString)
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16)] as [NSObject:AnyObject]
        
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
        var otherAttrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject:AnyObject]
        
        result.addAttributes(otherAttrs, range: range)
        
        return result
    }
    
    // MARK: - gesture
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let location = touch.locationInView(self)
        /*
        if self.iconKudos != nil && CGRectContainsPoint(self.iconKudos!.frame, location) {
            return false
        }
        */
        
        return true
    }
    
    func handleGesture(gesture:UIGestureRecognizer) {
        println("gesture")
        if gesture.isKindOfClass(UITapGestureRecognizer) && gesture.state == UIGestureRecognizerState.Ended {
            self.didTap()
        }
        else if gesture.isKindOfClass(UILongPressGestureRecognizer) {
            if gesture.state == UIGestureRecognizerState.Began {
                self.isPressing = true
                self.didPressDown()
            }
            else if gesture.state == UIGestureRecognizerState.Ended {
                if self.isPressing {
                    self.didPressUp()
                }
                self.isPressing = false
            }
        }
    }
    
    func bounce(completion: () -> Void) {
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue < 7.0 {
            completion()
            return
        }
        
        let duration:Double = 0.25
        let damping:CGFloat = 0.1
        let velocity:CGFloat = 3
        
        var sx:CGFloat = 1
        var sy:CGFloat = 1
        
        UIView.animateWithDuration(duration/3.0, animations: { () -> Void in
            sx = 0.9
            sy = 0.9
            self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy)
        }) { (finished) -> Void in
            UIView.animateWithDuration(duration*2/3, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                sx = 1
                sy = 1
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy)
            }, completion: { (finished) -> Void in
                completion()
            })
        }
    }
    
    func bounceForState(pressed_state:Int, completion: () -> Void) {
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue < 7.0 {
            completion()
            return
        }
        
        let duration:Double = 0.5
        let damping:CGFloat = 0.1
        let velocity:CGFloat = 3
        
        var sx:CGFloat = 1
        var sy:CGFloat = 1
        
        if pressed_state == 1 {
            // pressed
            UIView.animateWithDuration(duration/3.0, animations: { () -> Void in
                sx = 0.9
                sy = 0.9
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy)
                }) { (finished) -> Void in
                    println("done")
                    UIView.animateWithDuration(0.01, delay: 0.25, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        //self.contentView.transform = CGAffineTransformIdentity;
                    }, completion: { (finished) -> Void in
                    })
            }
        }
        else {
            // not pressed
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                sx = 1
                sy = 1
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy)
                }, completion: { (finished) -> Void in
                    completion()
            })
        }
    }
    
    func resetBounce() {
        
    }
    
    func didTap() {
        self.bounce { () -> Void in
            println("bounced")
            if self.delegate != nil && self.activity != nil {
                self.delegate!.didSelectActivityTile(self)
            }
        }
    }
    
    func didPressDown() {
        self.bounceForState(1, completion: { () -> Void in
            
        })
    }
    
    func didPressUp() {
        self.bounceForState(0, completion: { () -> Void in
            println("bounced")
            if self.delegate != nil && self.activity != nil {
                self.delegate!.didSelectActivityTile(self)
            }
        })
    }
}
