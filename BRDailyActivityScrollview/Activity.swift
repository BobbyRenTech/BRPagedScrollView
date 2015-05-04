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
    var type: ActivityType
    var iconName: String?
    var icon: UIImage?
    var text: String?
    var completed: Bool?
    var weight: CGFloat?
    var feetStatus: String?
    
    init(params:[String: Any]) {
        if let activityType = params["type"] as? ActivityType {
            self.type = activityType
            self.completed = params["completed"] as? Bool
            self.weight = params["weight"] as? CGFloat
            self.feetStatus = params["feetStatus"] as? String
            
            switch self.type {
            case ActivityType.Sponsored:
                self.text = "Get a flu shot"
                self.iconName = "cvs"
                break;
            case ActivityType.Weight:
                self.text = "Check your weight"
                self.iconName = "scale-blue"
                break;
            case ActivityType.Feet:
                self.text = "Check your feet"
                self.iconName = "foot-blue"
                break;
            case ActivityType.Glucose:
                self.text = "Check your glucose"
                self.iconName = "diabetes-blue"
                break;
            case ActivityType.Hunger:
                self.text = "How's your hunger?"
                self.iconName = "apple-blue"
                break;
            case ActivityType.Medicine:
                self.text = "Take your medicine"
                self.iconName = "pills-blue"
                break;
            case ActivityType.Feel:
                self.text = "How do you feel?"
                self.iconName = "person-blue"
                break;
            case ActivityType.Challenge:
                self.text = "Whole foods challenge"
                self.iconName = "wholefoods"
                break;
            default:
                break;
            }
        }
        else {
            self.type = ActivityType.Challenge
        }
        
        if self.iconName != nil {
            self.icon = UIImage(named: self.iconName!)
        }
        else {
            self.icon = nil
        }
    }
    
    func isWide()->Bool {
        return self.type == ActivityType.Sponsored || self.type == ActivityType.Challenge
    }

    func isTall()->Bool {
        return self.type == ActivityType.Weight || self.type == ActivityType.Medicine
    }
    
    func didCompleteWeight(weight:CGFloat) {
        self.completed = true
        self.weight = weight
        self.text = "Today's weight\n\(weight) lbs"
        self.iconName = "scale"
        self.icon = UIImage(named: self.iconName!)
    }
}
