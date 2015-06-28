//: Playground - noun: a place where people can play

import UIKit

class DataModel
{
  static let sharedInstance = DataModel()
  
  private init()
  { print("DataModel inited.");
  }
  
  
}

let dm0 = DataModel.sharedInstance
let dm1 = DataModel.sharedInstance
let dm2 = DataModel()