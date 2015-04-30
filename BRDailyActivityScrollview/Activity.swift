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
    case Wide
    case Tall
}

class Activity: NSObject {
    let type: ActivityType
    let icon: UIImage?
    let text: String?
    
    init(type:ActivityType, icon:UIImage?, text:String?) {
        self.type = type
        self.icon = icon
        self.text = text
    }
}
