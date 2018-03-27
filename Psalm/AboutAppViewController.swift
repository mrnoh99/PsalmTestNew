//
//  AboutAppViewController.swift
//  ListenToGospel
//
//  Created by NohJaisung on 2018. 3. 27..
//  Copyright © 2018년 NohJaisung. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "aboutThis" , withExtension: "rtf") {
            do {
                let data = try Data(contentsOf:url)
                let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                let fullText = attibutedString.string
                aboutTextView.text = fullText
                
            } catch {
                print(error)
            }
        }
        

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
