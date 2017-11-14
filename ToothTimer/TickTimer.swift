//
//  TickTimer.swift
//  ToothTimer
//
//  Created by Feldmaus on 19.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

/**
   A Class that measures time using the **mach_absolute_time** ticks.
 */
class TickTimer
{
  fileprivate var startTicks    : UInt64 = 0
  fileprivate var lapStartTicks : UInt64 = 0
  fileprivate var stopTicks     : UInt64 = 0
  
  /**
      Start the *timer*
      :param: `bla`
   */
  func start() -> Void
  { self.startTicks    = mach_absolute_time()
    self.lapStartTicks = self.startTicks
    self.stopTicks     = 0
  }
  
  /**
      Stop the **timer**
  */
  func stop() -> Double
  { self.stopTicks    = mach_absolute_time()
    
    return seconds( self.stopTicks - self.startTicks )
  }
  
  /**
      Get the ticks for a lap
  */
  func lap() -> Double
  { let lapStopTicks = mach_absolute_time()
    let result       = seconds( lapStopTicks-self.lapStartTicks )
    
    self.lapStartTicks = lapStopTicks
    
    return result
  }
  
  /**
      Calculates the elapsed seconds for the last elapsedTicks.
    
      :returns:  elapsed seconds.
   */
  fileprivate func seconds(_ ticks:UInt64) -> Double
  { var result = 0.0
    
    if ticks>0
    { var timeBaseInfo = mach_timebase_info()
      
      mach_timebase_info(&timeBaseInfo);
      
      let elapsedTimeNano = ticks * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom)
      
      result = Double(elapsedTimeNano) * 1.0E-9;
    } /* of if */
    
    return result
  }
}
