//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import UIKit


protocol ReadChapterViewControllerDelegate: class {
  func textChanged(text: String)
}

class ReadChapterViewController: UIViewController {
  
  weak var delegate: ReadChapterViewControllerDelegate?
  
  var arrayNumber: Int  {
    get{
      return selectedIndex
    }
    
  }
  
  
  
  
  
    @IBOutlet weak var readText: UITextView!
    
    var text: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
      readText.text = text
      

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
