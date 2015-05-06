//
//  CalendarHeaderDayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/6/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class CalendarHeaderDayViewController: UIViewController {

    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!
    
    var date:NSDate!
    var activities:[Activity]!

    let weekdays = ["Su", "M", "T", "W", "Th", "F", "S"]
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.date == nil {
            self.date = NSDate()
        }
        self.activities = [Activity]()
        dateFormatter.dateFormat = "dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDate(date:NSDate) {
        self.date = date
        
        labelDay.text = BRDateUtils.weekdayStringFromDate(date, GMT: false)
        let dateString = dateFormatter.stringFromDate(date)
        labelDate.text = dateString
    }
    
    func updateActivities(activities:[Activity]?, replaceExisting:Bool) {
        if replaceExisting {
            self.activities.removeAll(keepCapacity: false)
        }
        
        if activities != nil && activities!.count > 0 {
            // todo: check each individual one
            self.activities = self.activities + activities!
        }
        
        self.updateStatus()
    }
    
    func setIsCurrentDay(isCurrentDay:Bool) {
        // changes background icon depending on whether this day is being viewed
        if isCurrentDay {
            self.imageViewBG.image = UIImage(named: "weekdayWhite")
        }
        else {
            self.imageViewBG.image = UIImage(named:"weekdayGray")
        }
    }
    
    private func updateStatus() {
        if self.isComplete() {
            self.imageViewStatus.image = UIImage(named: "iconCheck");
        }
        else {
            self.imageViewStatus.image = UIImage(named: "iconX")
        }
    }
    private func isComplete() -> Bool {
        var completeCount: Int = 0
        for activity:Activity in self.activities {
            if activity.completed != nil && activity.completed! == true{
                completeCount += 1
            }
        }
        let percent:Float = Float(completeCount / self.activities.count)
        return percent >= 0.8
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
