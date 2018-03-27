//
//  QuestionViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 27..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import UIKit
import MessageUI

class QuestionViewController: UIViewController, MFMailComposeViewControllerDelegate{

  
    @IBOutlet weak var questionEmail: UIButton!
    
    @IBAction func questionEmail(_ sender: Any) {
    
    let composeVC = MFMailComposeViewController()
    composeVC.mailComposeDelegate = self
    
    // Configure the fields of the interface.
    composeVC.setToRecipients(["jsnoh2010@gmail.com"])
    composeVC.setSubject("시편읽기에 관하여 ")
    composeVC.setMessageBody("시편읽기에 대한 제안 ", isHTML: false)
    
    // Present the view controller modally.
    self.present(composeVC, animated: true, completion: nil)
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    
    
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


