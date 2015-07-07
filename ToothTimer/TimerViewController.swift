//
//  FirstViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController
{

  @IBOutlet weak var timeLabel  : UILabel!
  @IBOutlet weak var startButton: UIBarButtonItem!
  @IBOutlet weak var stopButton : UIBarButtonItem!
  @IBOutlet weak var customView : CustomView!
  
                 var actTimer   : Int = 0
            weak var timer      : NSTimer?
  
  override func viewDidLoad()
  { super.viewDidLoad()

    startButton.enabled = true
    stopButton.enabled  = false
    
    if let tintColor = UIColor.colorWithName(ColorName.tintColor.rawValue) as? UIColor
    { timeLabel.textColor = tintColor }
    
    self.updateTimerLabel()
  }

  func timerFired()
  { self.updateTimerLabel()
    
    actTimer--
    
    if actTimer<=0
    { _ = Log.createLog(Int32(AppConfig.sharedInstance().timerInSeconds),noOfSlices: Int16(AppConfig.sharedInstance().noOfSlices),status:"success")
      
      DataModel.sharedInstance.save()
      
      self.stopAction(nil)
    }
  }
  
  func updateTimerLabel()
  { timeLabel.text = String(format: "Time:%d", actTimer)
  }

  @IBAction func startAction(sender: UIBarButtonItem)
  { startButton.enabled = false
    stopButton.enabled  = true
    actTimer            = AppConfig .sharedInstance().timerInSeconds
    
    self.updateTimerLabel()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector("timerFired"), userInfo: nil, repeats: true)
    
    self.customView.addAnimation( CFTimeInterval(actTimer) )
  }
  
  @IBAction func stopAction(sender: UIBarButtonItem?)
  { timer?.invalidate()
    timer = nil
    
    startButton.enabled = true
    stopButton.enabled  = false
  }
}

