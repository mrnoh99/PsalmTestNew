//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import UIKit


protocol ReadChapterViewControllerDelegate: class {
  func textChanged(text: NSAttributedString)
}

class ReadChapterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  weak var delegate: ReadChapterViewControllerDelegate?
  var psalmChapterArray: [String] = []
  var headText: String = ""
  var bible: String = ""
  var playingResults: [Track] = []
  var chapterIndex : Int = 0
  
    @IBAction func refreshButtonPressed(_ sender: Any) {
        print ("refreshed pushed")
      
      psalmChapterArray = getChapterArray(forward: 0)
  UIView.transition(with: chapterTable, duration: 0.8, options: .transitionCrossDissolve , animations: {self.chapterTable.reloadData()}, completion: nil)
      
   
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
       print ("backward Pressed")
      psalmChapterArray = getChapterArray(forward: -1)
      UIView.transition(with: chapterTable, duration: 0.8, options: .transitionCurlDown , animations: {self.chapterTable.reloadData()}, completion: nil)
      
      
           }
    
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonPressed(_ sender: Any) {
      if audioPlayer != nil {
      if (audioPlayer?.isPlaying)! {
        self.playButton.setTitle("재생",for: .normal)
          audioPlayer?.pause()
        }else {
         self.playButton.setTitle("재생중단",for: .normal)
          audioPlayer?.play()
        }
      }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
   print ("foward Pressed")
      
      psalmChapterArray = getChapterArray(forward: 1)
      UIView.transition(with: chapterTable, duration: 0.6, options: .transitionCurlUp , animations: {self.chapterTable.reloadData()}, completion: nil)
        }
    
  var chapterNumber: Int  {
    get{
      //print(selectedIndex)
      return chapterIndex //selectedIndex
    }
  }
  

  
  var rightBarbuttonItem = UIBarButtonItem()
  
    @IBOutlet weak var chapterTable: UITableView!
  
    
    var text: NSAttributedString? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
      chapter = playingResults[selectedIndex].chapterIndex
      
      
    //  chapterNumber = chapterIndex
      rightBarbuttonItem =  UIBarButtonItem(title: "새번역", style: .done, target: self, action: #selector(changeKind))
      
      self.navigationItem.rightBarButtonItem = rightBarbuttonItem
      
      
      chapterTable.rowHeight = UITableViewAutomaticDimension
      chapterTable.estimatedRowHeight = 140 
      bible = "CCK"
      psalmChapterArray = getChapterArray(forward: 0)
       headText = "새번역 성경 시편 제" + String(chapterIndex + 1) + "편"
      
 
        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
  //    self.navigationController?.navigationBar.isTranslucent = false
   
    if audioPlayer != nil {
      if (audioPlayer?.isPlaying)! {
        self.playButton.setTitle("재생중단",for: .normal)
       
      }else {
        self.playButton.setTitle("재생",for: .normal)
        
      }
    }
    
    
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

@objc  func changeKind(){
  if self.rightBarbuttonItem.title == "새번역" {
    
   self.rightBarbuttonItem.title = "공동번역"
    bible = "KCB"
 
  } else {
    self.rightBarbuttonItem.title = "새번역"
    bible = "CCK"
  }
  psalmChapterArray = getChapterArray(forward: 0)
  UIView.transition(with: chapterTable, duration: 0.8, options: .transitionFlipFromBottom , animations: {self.chapterTable.reloadData()}, completion: nil)
  
  }

 
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
      
      return psalmChapterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  chapterTable.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! ChapterCell
      
      //  cell.delegate = self
      cell.chapterLabel.text = psalmChapterArray[indexPath.row]
    //  chapterTable.reloadData()
      return cell
    }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = UIColor.lightGray
    let myLabel: UILabel = UILabel(frame: CGRect(8,0,200,30))
    myLabel.textColor = .white
    myLabel.textAlignment = NSTextAlignment.left
    myLabel.text = headText
   header.addSubview(myLabel)
    
    return header
  }
  
  
  func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "test" //"시편 제" + String(selectedIndex + 1) + "편"
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 5
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let header = UIView.init()
    header.backgroundColor = UIColor.gray
    return header
  }
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
   return "시편 제" + String(chapterIndex) //(selectedIndex + 1) + "편"
    
  }
  
  
  
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//    }
    
  func getChapterArray(forward: Int) -> [String] {
   
    if forward != 0 {
    chapterIndex = chapterIndex + forward
    } else {
      chapterIndex = playingResults[confirmedIndex].chapterIndex
    }
    
    var realArray: [String] = []
   if chapterNumber != -1 {
      if  chapterNumber > 149 || chapterNumber < 0 {
        chapterIndex = playingResults[confirmedIndex].chapterIndex
      }
      
      if bible == "CCK" {
        self.headText = "새번역 성경 시편 제" + String(chapterNumber + 1) + "편"
      } else {
        self.headText = "공동번역 성경 시편 제" + String(chapterNumber + 1) + "편"
      }
      let bibleName = "Psa" + bible
    let separatedBy = "Psa " + "\(chapterNumber + 1)" + ":"
    let separatedBy2 = "Psa " + "\(chapterNumber + 2)" + ":"
      var array1: [String] = []
      if let url = Bundle.main.url(forResource: bibleName , withExtension: "rtf") {
            do {
                let data = try Data(contentsOf:url)
                let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
                let fullText = attibutedString.string
                let readings = fullText.components(separatedBy: separatedBy) //CharacterSet.newlines)
                
                for line in readings {
                    array1.append(line)
                }
              
               var array2 = array1[array1.count - 1].components(separatedBy: separatedBy2) //CharacterSet.newlines)
              
               for i in 1...array1.count - 2 {
                  realArray.append(array1[i])
                
                }
                realArray.append(array2[0])
                
                
            } catch {
             print (error)
                }
    
      } }

      return realArray
    }
  
}
