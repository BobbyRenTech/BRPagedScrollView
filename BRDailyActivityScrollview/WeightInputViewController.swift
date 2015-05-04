//
//  WeightInputViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/4/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

protocol WeightInputDelegate {
    func didDecrementWeight()
    func didIncrementWeight()
}

class WeightInputViewController: UIViewController {
    @IBOutlet weak var buttonMinus:UIButton!
    @IBOutlet weak var buttonPlus:UIButton!
    @IBOutlet weak var labelWeight:UILabel!
    
    var delegate:WeightInputDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeight(weight:CGFloat?) {
        if weight != nil {
            self.labelWeight.text = "\(weight) lbs"
        }
        else {
            self.labelWeight.text = "Enter your weight"
        }
    }
    
    @IBAction func didClickButton(sender:AnyObject!) {
        if self.delegate != nil {
            let button = sender as! UIButton
            if button == self.buttonMinus {
                self.delegate!.didDecrementWeight()
            }
            else if button == self.buttonPlus {
                self.delegate!.didIncrementWeight()
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
