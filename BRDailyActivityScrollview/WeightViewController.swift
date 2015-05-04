//
//  WeightViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/4/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

protocol WeightViewDelegate {
    func didEnterWeight(weight:CGFloat)
    func didCloseEnterWeight()
}


class WeightViewController: UIViewController {
    
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var inputWeight: UITextField!
    @IBOutlet weak var viewContent: UIView!

    var delegate: WeightViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContent.layer.borderColor = ColorUtil.blueColor().CGColor
        self.viewContent.layer.borderWidth = 1
        self.viewContent.layer.backgroundColor = UIColor.whiteColor().CGColor

        /*
        // layout issues!
        var keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.barStyle = UIBarStyle.Default
        keyboardDoneButtonView.translucent = false
        keyboardDoneButtonView.backgroundColor = UIColor.greenColor()
        var done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "done")
        var cancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "done")
        keyboardDoneButtonView.setItems([cancel, done], animated: true)
        self.inputWeight.inputAccessoryView = keyboardDoneButtonView
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.inputWeight.becomeFirstResponder()
    }
    
    @IBAction func done() {
        self.inputWeight.resignFirstResponder()
        if self.delegate != nil {
            if self.inputWeight.text != nil && count(self.inputWeight.text) > 0 {
                self.delegate!.didEnterWeight(CGFloat(self.inputWeight.text!.toInt()!))
            }
            else {
                self.delegate!.didCloseEnterWeight()
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