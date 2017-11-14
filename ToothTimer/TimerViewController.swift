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
  
            weak    var timer          : Timer?
                    var actTimer       : Int = 0
                    var tickTimer      : TickTimer = TickTimer()
  
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let keyPathValue = keyPath
    {
      print("observeValueForKeyPath:\(keyPathValue)")
      
      if keyPathValue=="noOfSlices" {
        self.circlesView.initView()
        self.circlesView.setNeedsLayout()
      }
    }
  }


  deinit {
    ToothTimerSettings.sharedInstance.removeObserver(self, forKeyPath: "noOfSlices")
  }


  override func viewDidLoad()
  { super.viewDidLoad()

    self.updateTimerLabel()
    self.slideButton.text = "Slide to start"
    
    ToothTimerSettings.sharedInstance.addObserver(self, forKeyPath: "noOfSlices", options: .new, context: nil)
  }

  
  func updateTimerLabel()
  { timerView.timeLabel.text = String(format: "%02d:%02d", actTimer/60,actTimer%60)
  }

  func startTimer()
  { if !self.isTimerRunning
    { self.isTimerRunning = true
      
      self.actTimer = ToothTimerSettings.sharedInstance.timerInSeconds!.intValue
      self.updateTimerLabel()
      
      self.tickTimer.start()
      self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerViewController.timerFired), userInfo: nil, repeats: true)
      
      self.circlesView.addAnimation( CFTimeInterval(actTimer) )
      self.slideButton.disappear()
      
      UIApplication.shared.isIdleTimerDisabled = true
    } /* of if */
  }
  
  func timerFired()
  { let elapsedTime = self.tickTimer.lap()
    print("elapsedTime:\(elapsedTime)")
    
    self.actTimer -= 1
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
      self.slideButton.appear()
      
      let elapsedTime = self.tickTimer.stop()
      print("stopp elapsedTime:\(elapsedTime)")
      
      self.isTimerRunning = false
      
      let log = CKLog()
      log.durationinseconds = Int64(elapsedTime)
      log.what = "toothtimer"
      
      CKLogsDataModel.sharedInstance.addLog(log)
      
      UIApplication.shared.isIdleTimerDisabled = false
      self.view.setNeedsLayout()
    } /* of if */
  }
  
  func toggleTimer()
  { if self.isTimerRunning
    { self.stopTimer() }
    else
    { self.startTimer() }
  }
  
  // MARK: Actions
  @IBAction func tappedAction(_ sender: AnyObject)
  { print("TimerView tapped")
    
    self.stopTimer()
  }
  
  @IBAction func swipAction(_ sender: AnyObject)
  { print("swipped")
    
    self.startTimer()
  }
  
}

