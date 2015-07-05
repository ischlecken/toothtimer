//
//  NSFileManager.swift
//  ToothTimer
//
//  Created by Feldmaus on 05.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

extension NSFileManager
{
  func copyToSharedLocationIfNotExists(fileName:String,fileType:String) throws -> Void
  { if let sfp = NSURL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
    fp  = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
  { if self.fileExistsAtPath(sfp)
  { try self.copyItemAtPath(fp, toPath: sfp) }
    } /* of if */
  }
  
  func copyToSharedLocation(fileName:String,fileType:String) throws -> Void
  { if let sfp = NSURL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
    fp  = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
  { if self.fileExistsAtPath(sfp)
  { try self.removeItemAtPath(sfp) }
    
    try self.copyItemAtPath(fp, toPath: sfp)
    } /* of if */
  }
  
  func copyIfModified(sourceURL:NSURL,destination:NSURL) throws -> Bool
  { var result : Bool = false
    
    if let sourcePath      = sourceURL.path,
      destinationPath = destination.path
    { var copyFile = !self.fileExistsAtPath(destinationPath)
      
      if !copyFile
      { let sourceFileSize = try self.attributesOfItemAtPath(sourcePath)[NSFileSize]      as! NSNumber
        let destFileSize   = try self.attributesOfItemAtPath(destinationPath)[NSFileSize] as! NSNumber
        
        if !sourceFileSize.isEqualToNumber(destFileSize)
        { copyFile = true }
      } /* of else */
      
      if copyFile
      { if self.fileExistsAtPath(destinationPath)
      { try self.removeItemAtPath(destinationPath) }
        
        try self.copyItemAtPath(sourcePath, toPath: destinationPath)
        
        result = true
      } /* of if */
    } /* of if */
    
    return result
  }
}