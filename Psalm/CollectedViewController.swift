//
//  CollectedViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 4. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class CollectedViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var collectedTable: UITableView!
    var collectedResults = [Collected]()
     var collectedService = CollectedService()
     @IBOutlet weak var statusButton: UIButton!
    let playViewController = PlayViewController()
  
  
  @IBAction func statusButtonPressed(_ sender: Any) {
     
      
      let data = confirmedColl
      self.performSegue(withIdentifier: "toPlayViewController", sender: data)
      
      
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.title = "시편듣기"
   //   self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
   //   self.navigationController?.navigationBar.shadowImage = UIImage()
   //   self.navigationController?.navigationBar.isTranslucent = false //true
   //   self.navigationController?.view.backgroundColor = .green //UIColor.clear
      
      
     
      do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])//.mixWithOthers)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        try AVAudioSession.sharedInstance().setActive(true)
      }catch let error {
        print(error.localizedDescription)
      }
     
      collectedResults = collectedService.getCollected()
      
      collectedTable.rowHeight = UITableViewAutomaticDimension
      collectedTable.estimatedRowHeight = 300
     }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
     self.navigationController?.navigationBar.isTranslucent = false
  }
  
  
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collectedResults.count
    }

  
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell =  collectedTable.dequeueReusableCell(withIdentifier: "collectedCell", for: indexPath) as! CollectedCell
      let collected: Collected
        collected = collectedResults[indexPath.row]
      cell.configure(collected: collected)
        return cell
    }
  
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 
*/

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedColl = collectedResults[indexPath.row]
    let data = collectedResults[indexPath.row]
    self.performSegue(withIdentifier: "toPlayViewController", sender: data)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "toPlayViewController") {
      let viewController:PlayViewController = segue.destination as! PlayViewController
      viewController.coll = sender as! Collected
      }
    }
  
 
  
  
}
