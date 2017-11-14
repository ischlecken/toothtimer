//
//  NSFileManager.swift
//  ToothTimer
//
//  Created by Feldmaus on 05.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

extension FileManager
{
  func copyToSharedLocationIfNotExists(_ fileName:String,fileType:String) throws -> Void
  { if let sfp = URL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
    let fp  = Bundle.main.path(forResource: fileName, ofType: fileType)
  { if self.fileExists(atPath: sfp)
  { try self.copyItem(atPath: fp, toPath: sfp) }
    } /* of if */
  }
  
  func copyToSharedLocation(_ fileName:String,fileType:String) throws -> Void
  { if let sfp = URL.appGroupURLForFileName("\(fileName).\(fileType)")?.path,
    let fp  = Bundle.main.path(forResource: fileName, ofType: fileType)
  { if self.fileExists(atPath: sfp)
  { try self.removeItem(atPath: sfp) }
    
    try self.copyItem(atPath: fp, toPath: sfp)
    } /* of if */
  }
  
  func copyIfModified(_ sourceURL:URL,destination:URL) throws -> Bool
  { var result : Bool = false
    
    let sourcePath      = sourceURL.path
    let destinationPath = destination.path
      
    var copyFile = !self.fileExists(atPath: destinationPath)
      
    if !copyFile
    { let sourceFileSize = try self.attributesOfItem(atPath: sourcePath)[FileAttributeKey.size]      as! NSNumber
      let destFileSize   = try self.attributesOfItem(atPath: destinationPath)[FileAttributeKey.size] as! NSNumber
      
      if !sourceFileSize.isEqual(to: destFileSize)
      { copyFile = true }
    } /* of else */
    
    if copyFile
    { if self.fileExists(atPath: destinationPath)
    { try self.removeItem(atPath: destinationPath) }
      
      try self.copyItem(atPath: sourcePath, toPath: destinationPath)
      
      result = true
    } /* of if */
  
    return result
  }
}
