//
//  DayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

let BORDER:CGFloat = 10

protocol DayViewDelegate {
    func didSelectActivityTile(controller:DayViewController, activity:Activity, canvas:UIView, frame:CGRect)
}

class DayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate {
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!

    var currentDate: NSDate?
    var activities: NSMutableArray!
    var delegate: DayViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        
        let appDelegate = UIApplication.sharedApplication().delegate!
        
        // default date is today
        if currentDate == nil {
            currentDate = BRDateUtils.beginningOfDate(NSDate(), GMT: false)
        }
        
        activities = NSMutableArray()
  
        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        layout.direction = UICollectionViewScrollDirection.Vertical
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        let GOLDEN_RATIO = 1.618 as CGFloat
        let width = CGFloat((self.view.frame.size.width)/2.0)
        let height = width / GOLDEN_RATIO
        layout.blockPixels = CGSizeMake(width, height)
        
        // because we want dayViewController to fade, the top part of the scrollable area needs to be blank.
        self.collectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
    }
    
    // MARK: Populating data
    func updateWithActivities(newActivities: [AnyObject]?) {
        if newActivities == nil || newActivities!.count == 0 {
            self.activities.removeAllObjects()
        }
        else {
            self.activities.addObjectsFromArray(newActivities!)
        }
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: ActivityCell;
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if activity.isTall() {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellTall", forIndexPath: indexPath) as! ActivityCell
        }
        else if activity.isWide() {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellWide", forIndexPath: indexPath) as! ActivityCell
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellSingle", forIndexPath: indexPath) as! ActivityCell
        }
        
        cell.setupWithActivity(activity)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: ActivityCell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! ActivityCell
        let frame = collectionView.convertRect(cell.frame, toView: self.view)
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if self.delegate != nil {
            self.delegate!.didSelectActivityTile(self, activity:activity, canvas:cell, frame: frame)
        }
    }
    
    // MARK: - RFQuiltLayoutDelegate
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if activity.isTall() {
            return CGSizeMake(1, 2);
        }
        else if activity.isWide() {
            return CGSizeMake(2, 1);
        }
        else {
            return CGSizeMake(1, 1);
        }
    }
    
    func insetsForItemAtIndexPath(indexPath: NSIndexPath!) -> UIEdgeInsets {
        let top:CGFloat = 0
        let left:CGFloat = BORDER
        let bottom:CGFloat = BORDER
        let right:CGFloat = 0
        return UIEdgeInsetsMake(top, left, bottom, right);
    }
    
    func maxCellWidth() -> CGFloat {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellWide", forIndexPath: indexPath) as! ActivityCell
        return cell.frame.size.width
    }
    
    // MARK: fake activities
    func loadActivities() {
        var activitiesArray = [AnyObject]()
        
        activitiesArray.append(self.sponsoredActivity())
        activitiesArray.append(Activity(params: ["type":ActivityType.Weight, "complete":false]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Glucose, "complete":false]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Feet, "complete":false]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Feel]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Medicine]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Hunger]))
        activitiesArray.append(self.challengeActivity())
        self.updateWithActivities(activitiesArray as [AnyObject])
    }
    
    func sponsoredActivity() -> Activity {
        // generate the sponsored CVS activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Sponsored]
        let activity = Activity(params: params)
        return activity
    }
    
    func challengeActivity() -> Activity {
        // generate the sponsored challenge activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Challenge]
        let activity = Activity(params: params)
        return activity
    }
}
