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
  class func playSound(_ soundName:String) -> Void
  { let soundPath               = Bundle.main.url(forResource: soundName, withExtension: "caf")
    var soundId : SystemSoundID = 0
    
    let createResult = AudioServicesCreateSystemSoundID(soundPath! as CFURL,&soundId)
    
    print("playSound(\(soundName)): path:\(soundPath) soundId:\(soundId) createResult:\(createResult)")
    
    if createResult==0
    { AudioServicesPlaySystemSound(soundId)
    }
  }
  
  class func vibrate() -> Void
  {
    AudioServicesPlaySystemSound( kSystemSoundID_Vibrate )
  }
}
