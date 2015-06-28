//
//  DAOModel.swift
//  ToothTimer
//
//  Created by Feldmaus on 28.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import CoreData

class DataModel
{
  static let sharedInstance = DataModel()
  
  init()
  { print("DataModel inited."); }
  
  func save()
  { let moc = DAOModel.sharedInstance().managedObjectContext
    
    do
    { try moc.save() }
    catch
    {
      NSLog("Error in MOC.save")
    }
    
    
  }
}