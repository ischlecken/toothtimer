//
//  UIColor.swift
//  ToothTimer
//
//  Created by Feldmaus on 05.07.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation

enum ColorName : String
{ case gradientColors = "gradientColors"
  case optionOnColor  = "optionOnColor"
  case tintColor      = "tintColor"
  case disabledColor  = "disabledColor"
  case iconColors     = "iconColors"
  case titleColor     = "titleColor"
}

extension UIColor
{
  fileprivate static var colorScheme : [String:AnyObject]?
  { var result : [String:AnyObject]? = nil
    
    do
    { try FileManager.default.copyToSharedLocation(Constant.kColorSchemeFileName,fileType:"json") }
    catch let error
    { print("Error while move colorscheme to appgroup directory:\(error)") }
    
    if let dataPath = URL.colorSchemeURL?.path, let data = try? Data(contentsOf: URL(fileURLWithPath: dataPath))
    { do
    { result = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : AnyObject] }
    catch let error
    { print("Error while reading json:\(error)") }
    } /* of if */
    
    return result!
  }
  
  fileprivate static var colorCache      = [String:AnyObject](minimumCapacity: 1)
  
  static var colorSchemeNames        : [String]?
  { var result : [String]? = nil
    
    if let s = UIColor.colorScheme
    { var r = [String]()
      
      for n in s.keys
      { r.append(n) }
      
      result = r
    } /* of if */
    
    return result
  }
  
  static var selectedColorSchemeName : String? = nil
  {
    didSet
    { UIColor.colorCache = [String:AnyObject](minimumCapacity: 10)
    }
  }
  
  static func colorWithName(_ colorName:String) -> AnyObject?
  { var result : AnyObject? = UIColor.colorCache[colorName]
    
    if result==nil
    { if let cs = UIColor.colorScheme, let currentColorScheme = cs[UIColor.selectedColorSchemeName!] as? [String:AnyObject]
      { if let colorValue = currentColorScheme[colorName] as? String
        { result = UIColor(hexString: colorValue)
        } /* of if */
        else if let colorValue = currentColorScheme[colorName] as? [String]
        { var colors = [UIColor]()
          
          for c in colorValue
          { colors.append(UIColor(hexString: c))
          }
          
          result = colors as AnyObject
        } /* of else if */
      } /* of if */
      
      if result != nil
      { UIColor.colorCache[colorName] = result }
    } /* of if */
    
    return result
  }
  
  convenience init(hexString:String)
  { if hexString.count==7 || hexString.count==9
    { let scanner           = Scanner(string: hexString)
      var rgbValue : UInt32 = 0;
      
      scanner.scanLocation = 1
      scanner.scanHexInt32(&rgbValue)
      
      let red   = CGFloat((rgbValue & 0xFF0000)>>16) / 255.0
      let green = CGFloat((rgbValue & 0xFF00  )>>8 ) / 255.0
      let blue  = CGFloat((rgbValue & 0xFF    )    ) / 255.0
      var alpha = CGFloat(1.0)
      
      if hexString.count == 9
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
  
  func cgColorToString() -> String
  { var result = ""
    
    if let components = self.cgColor.components {
      result = String(format: "#%0.2X%0.2X%0.2X%0.2X",
                          arguments: [Int(components[0]*255.0),
                                      Int(components[1]*255.0),
                                      Int(components[2]*255.0),
                                      Int(components[3]*255.0)])
    
    }
    
    return result
  }
  

}
