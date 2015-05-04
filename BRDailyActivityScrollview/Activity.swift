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
    case Single
    case Tall // more important activities for a user
    case Wide // sponsored activities, show on the top and bottom
}

let ActivityTypeSingle = "ActivityTypeSingle"
let ActivityTypeTall = "ActivityTypeTall"
let ActivityTypeWide = "ActivityTypeWide"

class Activity: NSObject {
    var type: ActivityType
    var icon: UIImage?
    var text: String?
    
    init(type:ActivityType, icon:UIImage?, text:String?) {
        self.type = type
        self.icon = icon
        self.text = text
    }
    
    init(params:NSDictionary) {
        self.type = ActivityType.Single
        if let activityType = params["type"] as? String {
            if activityType == ActivityTypeSingle {
                self.type = ActivityType.Single
            }
            else if activityType == ActivityTypeTall {
                self.type = ActivityType.Tall
            }
            else if activityType == ActivityTypeWide {
                self.type = ActivityType.Wide
            }
        }
        
        if let iconName = params["icon"] as? String {
            self.icon = UIImage(named: iconName)
        }
        else {
            self.icon = nil
        }
        
        if let activityText = params["text"] as? String {
            self.text = activityText
        }
        else {
            self.text = nil
        }
    }
    
    class func activityLabels() -> [String] {
        let labels = ["Check your weight", "Examine your feet", "Check your glucose", "Take meds", "Eat healthy", "Go exercise", "Get a flu shot"]
        return labels
    }
    
    func isWeightActivity()->Bool {
        return self.text == "Check your weight"
    }

    func isFootActivity()->Bool {
        return self.text == "Examine your feet"
    }
    
    func isMedsActivity() -> Bool {
        return self.text == "Take meds"
    }
    
    func activityType() -> ActivityType {
        if self.isWeightActivity() || self.isMedsActivity() {
            return ActivityType.Tall
        }
        else {
            return ActivityType.Single
        }
    }

}
