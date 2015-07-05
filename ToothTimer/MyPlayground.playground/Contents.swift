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


extension UIColor
{
  
  convenience init(hexString:String)
  { if hexString.characters.count==7 || hexString.characters.count==9
    { let scanner           = NSScanner(string: hexString)
      var rgbValue : UInt32 = 0;
      
      scanner.scanLocation = 1
      scanner.scanHexInt(&rgbValue)
      
      let red   = CGFloat((rgbValue & 0xFF0000)>>16) / 255.0
      let green = CGFloat((rgbValue & 0xFF00  )>>8 ) / 255.0
      let blue  = CGFloat((rgbValue & 0xFF    )    ) / 255.0
      var alpha = CGFloat(1.0)
      
      if hexString.characters.count==9
      { alpha = CGFloat((rgbValue & 0xFF000000)>>24) / 255.0
      } /* of if */
      
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    } /* of if */
    else
    { self.init(white:CGFloat(1.0),alpha:CGFloat(0.0)) }
  }
  
  func colorHexString() -> String
  { var result = String()
    var red    = CGFloat(0.0);
    var green  = CGFloat(0.0);
    var blue   = CGFloat(0.0);
    var alpha  = CGFloat(1.0);
    
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    result += "#"
    
    if alpha != 1.0
    { result += String(format: "%02lx", arguments: [UInt(alpha*255.0)])
    }
    
    result += String(format: "%02lx", arguments: [UInt(red*255.0)])
    result += String(format: "%02lx", arguments: [UInt(green*255.0)])
    result += String(format: "%02lx", arguments: [UInt(blue*255.0)])
    
    return result
  }
  
}


let color = UIColor(hexString:"#FFA090")

print("color:\(color.colorHexString())")

