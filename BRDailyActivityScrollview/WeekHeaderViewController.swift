//
//  WeekHeaderViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/1/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class WeekHeaderViewController: UIViewController {

    var weekStart: NSDate? // the morning of the Sunday of the week
    var weekEnd: NSDate? // the morning of the Saturday of the week
    var currentDate: NSDate?
    
    var weekIcons:[UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        weekIcons = [UIView]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDateInWeek(date: NSDate) {
        // sets any date in this week. will display sunday - thursday
        let sunday = BRDateUtils.sundayOfWeekForDate(date) as NSDate
        self.weekStart = sunday.dateByAddingTimeInterval(-7 * 24 * 3600) // sunday gives the weekend of current week
        self.weekEnd = sunday.dateByAddingTimeInterval(-1) // weekend is saturday evening 11:59:59 PM
        println("week range: \(self.weekStart) to \(self.weekEnd)")
    }
    
    func setCurrentDayOfWeek(date: NSDate) {
        if self.weekStart == nil || self.weekEnd == nil {
            return;
        }
        if date.timeIntervalSinceDate(self.weekStart!) < 0 || date.timeIntervalSinceDate(self.weekEnd!) > 0 {
            return;
        }
        self.currentDate = date
        self.updateWeekIcons()
    }
    
    func updateWeekIcons() {
        if self.weekStart != nil {
            for view in self.weekIcons! {
                view.removeFromSuperview()
            }
            self.weekIcons!.removeAll(keepCapacity: true)
            
            for i in 0 ... 6 {
                let date = self.weekStart!.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))
                
                let dayView = self.viewForDay(i, date: date) as UIView!
                self.view.addSubview(dayView)
                self.weekIcons!.append(dayView)
            }
        }
    }
    
    func viewForDay(dayIndex:Int, date:NSDate) -> UIView {
        let weekdays = ["Su", "M", "T", "W", "Th", "F", "S"]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        
        var width:Int = 50
        if self.view.frame.size.width == 320 {
            width = 40
        }
        let border:CGFloat = (self.view.frame.size.width - CGFloat(width * 7))/2
        let x = border + CGFloat(dayIndex * width)

        var frame = CGRectMake(x, 0, CGFloat(width), 70)
        var view = UIView(frame: frame)
        view.backgroundColor = UIColor.clearColor()
        
        // background
        frame = CGRectMake(0, 0, CGFloat(width), 70)
        var bg = UIImageView(frame: frame)
        bg.backgroundColor = UIColor.clearColor()
        bg.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(bg)

        // icon
        frame = CGRectMake(20, 13, 10, 10)
        var icon = UIImageView(frame: frame)
        icon.backgroundColor = UIColor.clearColor()
        icon.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(icon)

        // day of week
        frame = CGRectMake(5, 13, 30, 10)
        var labelDay = UILabel(frame: frame)
        labelDay.text = weekdays[dayIndex]
        labelDay.font = UIFont.systemFontOfSize(11)
        view.addSubview(labelDay)
        
        // date
        frame = CGRectMake(10, 15, 40, 40)
        var labelDate = UILabel(frame: frame)
        let dateString = dateFormatter.stringFromDate(date)
        labelDate.text = dateString
        labelDate.font = UIFont.boldSystemFontOfSize(18)
        view.addSubview(labelDate)
        
        if self.currentDate != nil && date == self.currentDate {
            bg.image = UIImage(named: "weekdayWhite")
            labelDay.textColor = UIColor.blackColor()
            labelDate.textColor = UIColor.blackColor()
        }
        else {
            bg.image = UIImage(named: "weekdayGray")
            labelDay.textColor = UIColor.whiteColor()
            labelDate.textColor = UIColor.whiteColor()
        }
        
        if date.timeIntervalSinceDate(BRDateUtils.beginningOfDate(NSDate(), GMT: false)) < 0 {
            icon.image = UIImage(named: "iconCheck");
        }
        else {
            icon.image = UIImage(named: "iconX")
        }

        return view
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
