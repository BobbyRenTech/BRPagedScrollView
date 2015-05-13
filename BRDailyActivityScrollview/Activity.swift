//
//  Activity.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/30/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

// ActivityType indicates whether the activity should be display in a certain way
enum ActivityType {
    case Sponsored
    case Weight
    case Feet
    case Glucose
    case Hunger
    case Medicine
    case Feel
    case Challenge
}

class Activity: NSObject {
    var activityWeight: Int = 0 // 0 = regular, 1 = sponsored (wide), 2 = tall, 3 = 2x2
    var type: ActivityType = ActivityType.Sponsored
    var date: NSDate?
    var sponsor: String?
    var text: String?
    var textComplete: String?
    var completed: Bool?
    
    var weight: CGFloat?
    var feetStatus: String?
    
    // icon information
    var iconStates: NSArray?
    
    init(params:[String: Any]) {
        if let activityType = params["type"] as? ActivityType {
            self.type = activityType
            self.completed = params["completed"] as? Bool
            self.weight = params["weight"] as? CGFloat
            self.feetStatus = params["feetStatus"] as? String
            self.date = params["date"] as? NSDate
            
            self.iconStates = params["icons"] as? NSArray
            
            switch self.type {
            case ActivityType.Sponsored:
                self.text = "Get a flu shot"
                self.sponsor = "cvs"
                self.activityWeight = 1
                break;
            case ActivityType.Weight:
                self.text = "Check your weight"
                self.activityWeight = 2
                break;
            case ActivityType.Feet:
                self.text = "Check your feet"
                self.textComplete = "Feet are clear today"
                self.feetStatus = "clear"
                break;
            case ActivityType.Glucose:
                self.text = "Check your glucose"
                self.textComplete = "Glucose checked"
                break;
            case ActivityType.Hunger:
                self.text = "How's your hunger?"
                self.textComplete = "Hunger logged"
                break;
            case ActivityType.Medicine:
                self.text = "Take your medicine"
                self.textComplete = "Medicine taken"
                self.activityWeight = 2
                break;
            case ActivityType.Feel:
                self.text = "How do you feel?"
                self.textComplete = "I feel good today"
                break;
            case ActivityType.Challenge:
                self.text = "Whole foods challenge\nWalk 10 miles in 7 days"
                self.sponsor = "wholefoods"
                self.activityWeight = 1
                break;
            default:
                break;
            }
        }
    }
    
    func isWide()->Bool {
        return self.activityWeight == 1
    }

    func isTall()->Bool {
        return self.activityWeight == 2
    }
    
    func isHuge()->Bool {
        return self.activityWeight == 3
    }
    
    func didCompleteWeight(weight:CGFloat) {
        self.completed = true
        self.weight = weight
    }
    
    // hack: quick way to know whether an icon show be displayed for an activity
    // todo: check actual activity parameters
    func hasReminders() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("reminders")
    }
    func hasStatus() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("status")
    }
    func hasMessages() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("messages")
    }
    func hasRewards() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("rewards")
    }
    func hasSpecial() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("special")
    }
    func hasKudos() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("kudos")
    }
    func isLocked() -> Bool {
        if self.iconStates == nil {
            return false;
        }
        return self.iconStates!.containsObject("lock")
    }

}
