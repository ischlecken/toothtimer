//
//  IAPProduct.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import StoreKit

class IAPProduct
{
  var productIdentifier:String
  var availableForPurchase = false
  var skProduct : SKProduct?
  var purchaseInProgress = false
  var purchased = false
  
  var allowedToPurchase : Bool {
    get {
      return self.availableForPurchase && !self.purchaseInProgress && !self.purchased
    }
  }
  
  init(productIdentifier:String)
  { self.productIdentifier = productIdentifier
  }
}