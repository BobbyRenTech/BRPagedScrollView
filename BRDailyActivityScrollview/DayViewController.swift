//
//  DayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate {
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!

    var currentDate: NSDate?
    var activities: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let appDelegate = UIApplication.sharedApplication().delegate!
        
        // default date is today
        if currentDate == nil {
            currentDate = NSDate()
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
        let width = self.view.frame.size.width - 20
        layout.blockPixels = CGSizeMake(10, 10)
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
        if activity.type == ActivityType.Tall {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellTall", forIndexPath: indexPath) as! ActivityCell
        }
        else if activity.type == ActivityType.Wide {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellWide", forIndexPath: indexPath) as! ActivityCell
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellSingle", forIndexPath: indexPath) as! ActivityCell
        }
        
        // Configure the cell
        cell.contentView.backgroundColor = self.randomColor()
        cell.labelText.text = activity.text
        
        return cell
    }
    
    // MARK: - RFQuiltLayoutDelegate
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if activity.type == ActivityType.Tall {
            return CGSizeMake(15, 23);
        }
        else if activity.type == ActivityType.Wide {
            return CGSizeMake(30, 15);
        }
        else {
            return CGSizeMake(15, 10);
        }
    }
    
    func insetsForItemAtIndexPath(indexPath: NSIndexPath!) -> UIEdgeInsets {
        let border = 25 as CGFloat
        return UIEdgeInsetsMake(0, border, border, 0);
    }
  
    // MARK: - Utils
    func randomColor() -> UIColor {
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
}
