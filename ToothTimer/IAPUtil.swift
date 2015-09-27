//
//  IAPUtil.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import StoreKit

typealias productsRequestCompletionType = (Bool,[IAPProduct]) -> Void

class IAPUtil : NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver
{
  let products : [IAPProduct]
  var productsRequest : SKProductsRequest?
  var productsRequestCompletion : productsRequestCompletionType?
  var transactionObserverAdded = false
  
  init(withProducts products:[IAPProduct]) {
    self.products = products
  }
  
  deinit {
    if self.transactionObserverAdded {
      SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
      self.transactionObserverAdded = false
    }
  }
  
  func requestProducts(withCompletion completion:productsRequestCompletionType?) {
    if !transactionObserverAdded {
      self.transactionObserverAdded = true
      SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    var productIdentifiers = Set<String>()
    
    for product in self.products {
      productIdentifiers.insert(product.productIdentifier)
      product.availableForPurchase = false
    }
    
    NSLog("products:\(productIdentifiers)")
    
    let productRequests = SKProductsRequest(productIdentifiers: productIdentifiers)
    self.productsRequest = productRequests
    self.productsRequestCompletion = completion
    
    productRequests.delegate = self
    productRequests.start()
  }
  
  func findProduct(usingProductIdentifier productIdentifier:String) -> IAPProduct? {
    var result : IAPProduct? = nil
    
    for product in self.products {
      if product.productIdentifier == productIdentifier {
        result = product
        
        break
      }
    }
    
    return result
  }
  
  // MARK: SKProductsRequestDelegate
  func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    NSLog("response:\(response)")
    
    for skProduct in response.products {
      let product = self.findProduct(usingProductIdentifier: skProduct.productIdentifier)
      
      if let product = product {
        product.availableForPurchase = true
        product.skProduct = skProduct
      }
    }
    
    for invalidProductIdentifier in response.invalidProductIdentifiers {
      let product = self.findProduct(usingProductIdentifier: invalidProductIdentifier)
      
      if let product = product {
        product.availableForPurchase = false
      }
    }
    
    if let productsRequestCompletion = self.productsRequestCompletion {
      productsRequestCompletion(true,self.products)
    }
    
    self.productsRequestCompletion = nil
  }
  
  func request(request: SKRequest, didFailWithError error: NSError) {
    if let productsRequestCompletion = self.productsRequestCompletion {
      productsRequestCompletion(false,self.products)
    }
    
    self.productsRequestCompletion = nil
  }
  
  // MARK: SKPaymentTransactionObserver
  func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      NSLog("transactionState:\(transaction.transactionState)")
      
      switch (transaction.transactionState) {
        case .Purchased,.Failed,.Restored:
          self.productArrived(transaction)
        default:
          break;
      }
    }
  }
  
  // MARK: ---
  
  func productArrived(transaction:SKPaymentTransaction) {
    let product = self.findProduct(usingProductIdentifier: transaction.payment.productIdentifier)
    
    if let product = product {
      product.purchaseInProgress = false
    }
    
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  func buyProduct(product:IAPProduct) {
    if let skProduct = product.skProduct where product.availableForPurchase {
      NSLog("Buying %@...", product.productIdentifier);
      
      product.purchaseInProgress = true;
      
      let payment = SKPayment(product: skProduct)
      
      SKPaymentQueue.defaultQueue().addPayment(payment);
    }
  }
  


}