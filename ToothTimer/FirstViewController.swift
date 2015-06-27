//
//  FirstViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController
{

  @IBOutlet weak var timeLabel: UILabel!
  
  override func viewDidLoad()
  { super.viewDidLoad()

    timeLabel.text = String(format: "Time:%d", AppConfig .sharedInstance().timerInSeconds)
  }


}

