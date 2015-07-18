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
            dynamic var isTimerRunning : Bool = false
  @IBOutlet weak    var timeLabel      : UILabel!
  @IBOutlet weak    var customView     : CustomView!
                    var actTimer       : Int = 0
            weak    var timer          : NSTimer?
  
  override func viewDidLoad()
  { super.viewDidLoad()

    if let tintColor = UIColor.colorWithName(ColorName.tintColor.rawValue) as? UIColor
    { timeLabel.textColor = tintColor }
    
    self.updateTimerLabel()
  }

  @IBAction func tappedAction(sender: AnyObject)
  { NSLog("TimerView tapped")
    
    self.toggleTimer()
  }
  
  func timerFired()
  { self.updateTimerLabel()
    
    actTimer--
    
    if actTimer<=0
    { _ = Log.createLog(Int32(AppConfig.sharedInstance().timerInSeconds),noOfSlices: Int16(AppConfig.sharedInstance().noOfSlices),status:"success")
      
      DataModel.sharedInstance.save()
      self.updateTimerLabel()
      
      self.stopTimer()
    }
  }
  
  func updateTimerLabel()
  { timeLabel.text = String(format: "%02d:%02d", actTimer/60,actTimer%60)
  }

  func startTimer()
  { if !self.isTimerRunning
    { self.isTimerRunning = true
      
      self.actTimer = AppConfig .sharedInstance().timerInSeconds
      
      self.updateTimerLabel()
      
      self.timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: Selector("timerFired"), userInfo: nil, repeats: true)
      
      self.customView.addAnimation( CFTimeInterval(actTimer) )
      
    } /* of if */
  }
  
  func stopTimer()
  { if self.isTimerRunning
    { self.timer?.invalidate()
      self.timer = nil
    
      self.customView.removeAnimation()
      
      self.isTimerRunning = false
    } /* of if */
  }
  
  func toggleTimer()
  { if self.isTimerRunning
    { self.stopTimer() }
    else
    { self.startTimer() }
  }
}

