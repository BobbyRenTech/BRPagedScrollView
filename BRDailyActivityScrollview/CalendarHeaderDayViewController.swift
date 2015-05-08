//
//  CalendarHeaderDayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/6/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

let COMPLIANCE_PERCENT = Float(0.2) // 2 activities or more

class CalendarHeaderDayViewController: UIViewController {

    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!
    
    var date:NSDate!
    var activities:NSMutableArray!

    let weekdays = ["M", "T", "W", "Th", "F", "S", "Su"]
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.date == nil {
            self.date = NSDate()
        }
        self.activities = NSMutableArray()
        dateFormatter.dateFormat = "dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate(date:NSDate) {
        self.date = date
        
        self.labelDay.text = BRDateUtils.weekdayStringFromDate(date, arrayStartingWithMonday: weekdays, GMT: false)
        let dateString = dateFormatter.stringFromDate(date)
        self.labelDate.text = dateString
        
        self.stopListeningFor("activities:updated:forDate")
        self.listenFor("activities:updated:forDate", action: "handleActivitiesUpdated:", object:date)
    }
    
    func updateActivities(activities:NSArray?, replaceExisting:Bool) {
        if replaceExisting {
            self.activities.removeAllObjects()
        }
        
        if activities != nil && activities!.count > 0 {
            // todo: check each individual one
            for activity in activities! as! [Activity] {
                self.addOrUpdateActivity(activity)
            }
        }
        
        self.updateStatus()
    }
    
    private func addOrUpdateActivity(newActivity:Activity) {
        // todo: refactor or remove this method if using core data
        // assume only one of each type, use type as unique key
        let array = self.activities as NSArray
        for activity in array as! [Activity] {
            if activity.type == newActivity.type {
                println("replacing activity of type \(activity.type)")
                self.activities.replaceObjectAtIndex(self.activities.indexOfObject(activity), withObject: newActivity)
                return
            }
        }
        
        println("adding new activity of type \(newActivity.type)")
        self.activities.addObject(newActivity)
    }
    
    func setIsCurrentDay(isCurrentDay:Bool) {
        // changes background icon depending on whether this day is being viewed
        if isCurrentDay {
            self.imageViewBG.image = UIImage(named: "weekdayWhite")
            self.labelDate.textColor = UIColor.darkGrayColor()
            self.labelDay.textColor = UIColor.darkGrayColor()
        }
        else {
            self.imageViewBG.image = UIImage(named:"weekdayGray")
            self.labelDate.textColor = UIColor.whiteColor()
            self.labelDay.textColor = UIColor.whiteColor()
        }
    }
    
    private func updateStatus() {
        self.imageViewStatus.backgroundColor = UIColor.clearColor()
        let frame = self.imageViewStatus.frame
        
        if self.isComplete() {
            self.imageViewStatus.image = UIImage(named: "iconCheck");
        }
        else {
            if self.date.timeIntervalSinceDate(BRDateUtils.beginningOfDate(NSDate(), GMT: false)) >= 0 {
                self.imageViewStatus.image = nil
            } else {
                self.imageViewStatus.image = UIImage(named: "iconX")
            }
        }
    }
    private func isComplete() -> Bool {
        var completeCount: Int = 0
        var completableCount: Int = 0
        
        let array = self.activities as NSArray
        if array.count == 0 {
            return false
        }
        
        // iterate through activities and count complete statuses
        for activity in array as! [Activity] {
            // skip sponsored/challenge activities
            if activity.type == ActivityType.Sponsored || activity.type == ActivityType.Challenge {
                continue
            }

            completableCount += 1
            if activity.completed != nil && activity.completed! == true{
                completeCount += 1
            }
        }
        let percent:Float = Float(completeCount) / Float(completableCount)
        return percent >= COMPLIANCE_PERCENT
    }
    
    // MARK: - Notifications
    func handleActivitiesUpdated(n:NSNotification) {
        let userInfo = n.userInfo
        if userInfo != nil {
            let activities = userInfo!["activity"] as? [Activity]
            if activities != nil {
                self.updateActivities(activities, replaceExisting: false)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
