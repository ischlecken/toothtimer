//
//  IAPUtil.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.09.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import Foundation
import StoreKit

typealias productsRequestCompletionType = (Bool,[String:IAPProduct]) -> Void

class IAPUtil : NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver
{
  let products : [String:IAPProduct]
  var productsRequest : SKProductsRequest?
  var productsRequestCompletion : productsRequestCompletionType?
  var transactionObserverAdded = false
  
  init(withProducts products:[String:IAPProduct]) {
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
    
    for (productIdentifier,product) in self.products {
      productIdentifiers.insert(productIdentifier)
      product.availableForPurchase = false
    }
    
    self.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    self.productsRequestCompletion = completion
  }
  
  // MARK: SKProductsRequestDelegate
  func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    for skProduct in response.products {
      self.products[skProduct.productIdentifier]?.availableForPurchase = true
      self.products[skProduct.productIdentifier]?.skProduct = skProduct
    }
    
    for invalidProductIdentifier in response.invalidProductIdentifiers {
      self.products[invalidProductIdentifier]?.availableForPurchase = false
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
    let product = self.products[transaction.payment.productIdentifier]
    product?.purchaseInProgress = false
    
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
  }
  
  func buyProduct(product:IAPProduct) {
    
    if let skProduct = product.skProduct {
      NSLog("Buying %@...", product.productIdentifier);
      
      product.purchaseInProgress = true;
      
      let payment = SKPayment(product: skProduct)
      
      SKPaymentQueue.defaultQueue().addPayment(payment);
    }
  }
  


}