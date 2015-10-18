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
  @IBOutlet weak    var circlesView    : CirclesView!
  @IBOutlet weak    var timerView      : TimerView!
  @IBOutlet weak    var slideButton    : SlideButton!

  @IBOutlet weak    var circleButton1  : CircleButton!
  @IBOutlet weak    var circleButton2  : CircleButton!
  @IBOutlet weak    var circleButton3  : CircleButton!
  @IBOutlet weak    var circleButton4  : CircleButton!
  
            weak    var timer          : NSTimer?
                    var actTimer       : Int = 0
                    var tickTimer      : TickTimer = TickTimer()
  
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if let keyPathValue = keyPath
    {
      NSLog("observeValueForKeyPath:\(keyPathValue)")
      
      if keyPathValue=="noOfSlices" {
        self.circlesView.updateGeometry()
        self.circlesView.setNeedsDisplay()
      }
    }
  }


  deinit {
    ToothTimerSettings.sharedInstance.removeObserver(self, forKeyPath: "noOfSlices")
  }


  override func viewDidLoad()
  { super.viewDidLoad()

    self.updateTimerLabel()
    
    ToothTimerSettings.sharedInstance.addObserver(self, forKeyPath: "noOfSlices", options: .New, context: nil)
  }

  
  
  func updateTimerLabel()
  { timerView.timeLabel.text = String(format: "%02d:%02d", actTimer/60,actTimer%60)
  }

  func startTimer()
  { if !self.isTimerRunning
    { self.isTimerRunning = true
      
      self.actTimer = ToothTimerSettings.sharedInstance.timerInSeconds!.integerValue
      self.updateTimerLabel()
      
      self.tickTimer.start()
      self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("timerFired"), userInfo: nil, repeats: true)
      
      self.circlesView.addAnimation( CFTimeInterval(actTimer) )
      
      UIApplication.sharedApplication().idleTimerDisabled = true
    } /* of if */
  }
  
  func timerFired()
  { let elapsedTime = self.tickTimer.lap()
    NSLog("elapsedTime:\(elapsedTime)")
    
    self.actTimer--
    self.updateTimerLabel()
    
    if self.actTimer<=0
    { self.stopTimer()
    }
  }
  
  func stopTimer()
  { if self.isTimerRunning
    { self.timer?.invalidate()
      self.timer = nil
    
      self.circlesView.removeAnimation()
      
      let elapsedTime = self.tickTimer.stop()
      NSLog("stopp elapsedTime:\(elapsedTime)")
      
      self.isTimerRunning = false
      
      let log = CKLog()
      log.durationinseconds = Int64(elapsedTime)
      log.what = "toothtimer"
      
      CKLogsDataModel.sharedInstance.addLog(log)
      
      UIApplication.sharedApplication().idleTimerDisabled = false
    } /* of if */
  }
  
  func toggleTimer()
  { if self.isTimerRunning
    { self.stopTimer() }
    else
    { self.startTimer() }
  }
  
  // MARK: Actions
  @IBAction func tappedAction(sender: AnyObject)
  { NSLog("TimerView tapped")
    
    self.toggleTimer()
  }
}

