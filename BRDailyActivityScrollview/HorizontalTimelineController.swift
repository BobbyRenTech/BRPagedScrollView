//
//  HorizontalTimelineController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class HorizontalTimelineController: UIViewController {

    @IBOutlet weak var scrollview : UIScrollView!
//    @IBOutlet weak var contentView : UIView!
    
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.populateDays()
    }

    func populateDays() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let width = appDelegate.window!.frame.size.width
        let height = appDelegate.window!.frame.size.height

        let days = arc4random_uniform(5) + 3
        for index in 0...days-1 {
            let i = CGFloat(index)
            var frame = appDelegate.window!.frame as CGRect
            frame.origin.x = i * width
            
            let dayController = storyboard!.instantiateViewControllerWithIdentifier("DayScrollViewController") as! DayScrollViewController
            self.addChildViewController(dayController)
            dayController.view.frame = frame

            self.scrollview.insertSubview(dayController.view, atIndex: 0)
            dayController.didMoveToParentViewController(self)
        }
        
        self.scrollview.contentSize = CGSizeMake(CGFloat(days)*width + 50, height)
        
    }
}

