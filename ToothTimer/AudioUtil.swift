//
//  AudioUtil.swift
//  ToothTimer
//
//  Created by Feldmaus on 19.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//
import Foundation
import AudioToolbox

class AudioUtil
{
  class func playSound(soundName:String) -> Void
  { let soundPath               = NSBundle.mainBundle().URLForResource(soundName, withExtension: "caf")
    var soundId : SystemSoundID = 0
    
    AudioServicesCreateSystemSoundID(soundPath!,&soundId)
    
    AudioServicesPlaySystemSound(soundId)
  }
}