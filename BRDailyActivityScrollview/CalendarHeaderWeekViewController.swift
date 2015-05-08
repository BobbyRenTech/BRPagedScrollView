//
//  CalendarWeekHeaderViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/1/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class CalendarHeaderWeekViewController: UIViewController {

    var weekStart: NSDate? // the morning of the Sunday of the week
    var weekEnd: NSDate? // the morning of the Saturday of the week
    var currentDate: NSDate?
    
    var weekdays:[CalendarHeaderDayViewController]!
    var didInitViews: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        weekdays = [CalendarHeaderDayViewController]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width:CGFloat = (self.view.frame.size.width - 20) / 7
        for i in 0 ... 6 {
            let dayController: CalendarHeaderDayViewController = storyboard!.instantiateViewControllerWithIdentifier("CalendarHeaderDayViewController") as! CalendarHeaderDayViewController
            let frame:CGRect = CGRectMake(10 + width * CGFloat(i), 0, width, self.view.frame.size.height)
            dayController.view.frame = frame
            
            if !self.didInitViews {
                self.view.addSubview(dayController.view)
                self.weekdays.append(dayController)
            }
        }
        
        if !self.didInitViews {
            self.setDateInWeek(NSDate())
        }
        
        self.didInitViews = true
    }
    
    func setDateInWeek(date: NSDate) {
        // sets any date in this week. will display sunday - thursday
        let sunday = BRDateUtils.sundayOfWeekForDate(date) as NSDate
        self.weekStart = sunday.dateByAddingTimeInterval(-7 * 24 * 3600) // sunday gives the weekend of current week. we want sunday to be the beginning of the week
        self.weekEnd = sunday.dateByAddingTimeInterval(-1) // weekend is saturday evening midight (sunday of next week)
        println("week range: \(self.weekStart) to \(self.weekEnd)")
        
        self.updateWeekIcons()

        /*
        var date:NSDate
        for date = self.weekStart!; date.timeIntervalSinceDate(self.weekEnd!) < 0; date = date.dateByAddingTimeInterval(24*3600) {
            self.listenFor("activities:changed", action: "updateActivitiesForDate:", object: date)
        }
        */
    }
    
    func setCurrentDayOfWeek(date: NSDate) {
        if self.weekStart == nil || self.weekEnd == nil {
            return;
        }
        if date.timeIntervalSinceDate(self.weekStart!) < 0 || date.timeIntervalSinceDate(self.weekEnd!) > 0 {
            return;
        }
        self.currentDate = date
        
        for i in 0 ... 6 {
            let dayController:CalendarHeaderDayViewController = self.weekdays[i]
            if dayController.date == self.currentDate {
                dayController.setIsCurrentDay(true)
            }
            else {
                dayController.setIsCurrentDay(false)
            }
        }
    }
    
    func updateWeekIcons() {
        if self.weekStart != nil {
            for i in 0 ... 6 {
                let date = self.weekStart!.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))
                
                let dayController:CalendarHeaderDayViewController = self.weekdays[i]
                dayController.updateDate(date)
                dayController.setIsCurrentDay(false)
            }
        }
        if self.currentDate != nil {
            self.setCurrentDayOfWeek(self.currentDate!)
        }
    }
    
    func updateActivitiesForDate(activities:NSMutableArray?, date:NSDate!) {
        for i in 0 ... 6 {
            let dayController:CalendarHeaderDayViewController = self.weekdays[i]
            if dayController.date == date {
                dayController.updateActivities(activities, replaceExisting: true)
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
