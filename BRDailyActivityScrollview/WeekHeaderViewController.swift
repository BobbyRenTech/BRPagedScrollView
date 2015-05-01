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
                let today = self.weekStart!.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))
                
                let dayView = self.viewForDay(i, date: today) as UIView!
                self.view.addSubview(dayView)
                self.weekIcons!.append(dayView)
            }
        }
    }
    
    func viewForDay(dayIndex:Int, date:NSDate) -> UIView {
        let weekdays = ["Su", "M", "T", "W", "Th", "F", "S"]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        let border:CGFloat = (self.view.frame.size.width - (55 * 7))/2
        let x = border + CGFloat(dayIndex * 55)
        var frame = CGRectMake(x, 0, 50, 70)
        var view = UIView(frame: frame)
        frame = CGRectMake(5, 5, 10, 10)
        var label = UILabel(frame: frame)
        label.text = weekdays[dayIndex]
        view.addSubview(label)
        frame = CGRectMake(10, 20, 30, 30)
        var label2 = UILabel(frame: frame)
        let dateString = dateFormatter.stringFromDate(date)
        label2.text = dateString
        view.addSubview(label2)
        
        if self.currentDate != nil && date == self.currentDate {
            label2.textColor = UIColor.blackColor()
            view.backgroundColor = UIColor.whiteColor()
        }
        else {
            label2.textColor = UIColor.whiteColor()
            view.backgroundColor = UIColor.blackColor()
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
