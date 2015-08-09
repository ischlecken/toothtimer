//
//  LogViewController.swift
//  ToothTimer
//
//  Created by Feldmaus on 27.06.15.
//  Copyright © 2015 ischlecken. All rights reserved.
//

import UIKit
import CoreData

class BadgeTableViewController: UITableViewController,NSFetchedResultsControllerDelegate
{
                 var badges      : NSFetchedResultsController!
  
  override func viewDidLoad()
  { super.viewDidLoad()
    
    badges = Badge.FetchedResultsController()
    badges.delegate = self
    
    self.tableView.backgroundColor = UIColor.clearColor()
    
    do
    { try badges.performFetch() }
    catch
    { NSLog("performFetch failed") }
  }


  //
  //
  //
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  { return (badges.sections?.count)! }

  //
  //
  //
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  { var result = 0
    
    if let s=badges.sections
    { result = s[section].numberOfObjects }
    
    return result
  }

  //
  //
  //
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  { let cell   = tableView.dequeueReusableCellWithIdentifier("badgeCell", forIndexPath: indexPath) as! BadgeTableViewCell
    let badge  = badges.objectAtIndexPath(indexPath) as! Badge
    
    cell.badgeNameLabel.text      = badge.name
    cell.badgeTimestampLabel.text = "ts:\(badge.createts)"
    cell.badgeImageView.image     = UIImage(named: "badge-"+badge.name)
      
    cell.badgeImageView.image     = cell.badgeImageView.image?.circleImageWithSize((cell.badgeImageView.image?.size)!,
      circleColor: UIColor.colorWithName(ColorName.titleColor.rawValue) as! UIColor,
      disabled: false)
    
    cell.badgeImageView.image     = cell.badgeImageView.image?.dropShadow(UIColor.whiteColor())
    
    return cell
  }
  
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
  {
    switch(type) {
      
    case .Insert:
      if let newIndexPath = newIndexPath {
        tableView.insertRowsAtIndexPaths([newIndexPath],
          withRowAnimation:UITableViewRowAnimation.Fade)
      }
      
    case .Delete:
      if let indexPath = indexPath {
        tableView.deleteRowsAtIndexPaths([indexPath],
          withRowAnimation: UITableViewRowAnimation.Fade)
      }
      
    case .Update:
      if let indexPath = indexPath {
        tableView.cellForRowAtIndexPath(indexPath)
      }
      
    case .Move:
      if let indexPath = indexPath {
        if let newIndexPath = newIndexPath {
          tableView.deleteRowsAtIndexPaths([indexPath],
            withRowAnimation: UITableViewRowAnimation.Fade)
          tableView.insertRowsAtIndexPaths([newIndexPath],
            withRowAnimation: UITableViewRowAnimation.Fade)
        }
      }
    }
  }
  
  func controller(controller: NSFetchedResultsController,
    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
    atIndex sectionIndex: Int,
    forChangeType type: NSFetchedResultsChangeType)
  {
    switch(type) {
      
    case .Insert:
      tableView.insertSections(NSIndexSet(index: sectionIndex),
        withRowAnimation: UITableViewRowAnimation.Fade)
      
    case .Delete:
      tableView.deleteSections(NSIndexSet(index: sectionIndex),
        withRowAnimation: UITableViewRowAnimation.Fade)
      
    default:
      break
    }
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController)
  {
    tableView.endUpdates()
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
