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
    
    let BORDER:CGFloat = 5.0
    
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
        let pagewidth = appDelegate.window!.frame.size.width
        let width = appDelegate.window!.frame.size.width - 2 * BORDER
        let height = appDelegate.window!.frame.size.height - 2 * BORDER

        let days = 10 // arc4random_uniform(5) + 3
        for index in 0...days-1 {
            let i = CGFloat(index)
            var frame = appDelegate.window!.frame as CGRect
            frame.origin.x = i * pagewidth + BORDER
            frame.origin.y = BORDER
            frame.size.width -= 2 * BORDER
            frame.size.height -= 2 * BORDER
            
            let dayController = storyboard!.instantiateViewControllerWithIdentifier("DayScrollViewController") as! DayScrollViewController
            self.addChildViewController(dayController)
            dayController.view.frame = frame

            self.scrollview.addSubview(dayController.view)
            dayController.didMoveToParentViewController(self)
        }
        
        self.scrollview.contentSize = CGSizeMake(CGFloat(days)*width + 50, height)
    }
}

