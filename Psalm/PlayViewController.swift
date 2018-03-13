//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreGraphics


class PlayViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var playTableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    

  
  
  
   var pauseButton = UIBarButtonItem()
    var playButton = UIBarButtonItem()
    var arrayOfButtons = [AnyObject]()
  
    var playResults: [Track] = []
     let queryService = QueryService()
  
  
  
  
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
      do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        print ("playbackOK")
        try AVAudioSession.sharedInstance().setActive(true)
        print("session is active")
      }catch let error {
        print(error.localizedDescription)
      }
    
  
      
      pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(pauseButtonTapped(sender:)))
      playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(playButtonTapped(sender: )))
      arrayOfButtons = self.toolBar.items!
      
      playResults = queryService.getSearchResults()
      searchViewController.checkDownloaded(results: playResults)
      
//      playTableView.tableFooterView = UIView()
//
//      playTableView.reloadData()
//      playTableView.setContentOffset(CGPoint.zero, animated: false)
//
      // Do any additional setup after loading the view.
      
    
      
  }
  
      
  override  func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(true)
    print("\(selectedIndex)")
    
    
    arrayOfButtons.remove(at: 4)
    
    if nowPlaying  {
      print ("pauseuttoninsered")
      print (nowPlaying)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
    } else {
      arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
      print ("playbutton inserted")
      print (nowPlaying)
    }
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
   
    if selectedIndex != -1 {
     
      if audioPlayer != nil {
      if (audioPlayer?.isPlaying)! {
       // let nowPlayingIndexPath = IndexPath(item: selectedIndex, section: 0)
         let track = playResults[selectedIndex]
         track.isPlaying = true
        nowPlayingLabel.text =  "  재생중:  " + playResults[selectedIndex].firstLine
        nowPlayingLabel.textColor = .red
      } else {
        nowPlayingLabel.text =  "재생중단:  " + playResults[selectedIndex].firstLine
        nowPlayingLabel.textColor = UIColor.darkGray
        }
      
    }
 
  }
  reloadTable()
    
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @objc  func playerChangedChapter(note:NSNotification) {
   
    
  }
  
    
  @IBAction func ffButtonPressed(_ sender: UIBarButtonItem) {
    
    if selectedIndex == playResults.count - 1 {
        selectedIndex = -1
      }
      if selectedIndex < playResults.count - 1{
        //Increment current index
        repeat {selectedIndex += 1
          if selectedIndex == playResults.count {
            selectedIndex = 0}
        } while self.playResults[selectedIndex].downloaded == false
        
        playMusic(selectedIndex: selectedIndex)
        
        nowPlaying = (audioPlayer?.isPlaying)!    }
      
     reloadTable()
  }
    
  
  
    
  @IBAction func rewindButtonPressed(_ sender: UIBarButtonItem) {
    if selectedIndex == 0 || selectedIndex == -1 {
      selectedIndex = playResults.count 
      
    }
    
    if selectedIndex > 0 {
      //
      repeat {selectedIndex -= 1
        if selectedIndex == 0{
          selectedIndex = playResults.count - 1}
      } while self.playResults[selectedIndex].downloaded == false
    
      playMusic(selectedIndex: selectedIndex)
      
  }
    
    reloadTable()
    
  }
  
    
    
    
  @objc  func playButtonTapped(sender: Any) {
  print ("playpressed")
  
    if audioPlayer != nil {
    audioPlayer?.play()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      
      nowPlayingLabel.text =  "  재생중:  " + playResults[selectedIndex].firstLine
      nowPlayingLabel.textColor = .red
  
    } else {
      selectedIndex = 0
      playMusic(selectedIndex: selectedIndex)
    }
    reloadTable()
  }
  
  @objc  func pauseButtonTapped(sender: Any) {
  print("pausedPressed")
    if audioPlayer != nil {
      audioPlayer?.pause()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      nowPlayingLabel.text =  "재생중단:  " + playResults[selectedIndex].firstLine
      nowPlayingLabel.textColor = UIColor.darkGray
  
      
    }
    reloadTable()
    
  }
  

  
 
  
  
}
// MARK: - UITableView

extension PlayViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return playResults.count
  }
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //  let cell: PlayCell = playTableView.dequeueReusableCell(for: indexPath)
     let cell = playTableView.dequeueReusableCell(withIdentifier: "playCell") as! PlayCell
    // Delegate cell button tap events to this view controller
    cell.delegate = self
    
    let track = playResults[indexPath.row]

    cell.configure(track: track)
    
    //, download: downloadService.activeDownloads[track.previewURL])
    
    return cell
  }
  

  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 62.0
  }
  
  // When user taps cell, play the local file, if it's downloaded
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let track = playResults[indexPath.row]
    selectedIndex = indexPath.row
    
    
    if  playResults[indexPath.row].downloaded == true {
      
      playResults[indexPath.row].isPlaying = true
      
      playMusic(selectedIndex: selectedIndex)
    //  nowPlaying = (audioPlayer?.isPlaying)!
      arrayOfButtons.remove(at: 4)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      reloadTable()
      
      
    } else {
      connectionAlert(title: "설치필요", message: "설치메뉴로 돌아가 재설치후 재생하십시오")
      
    }
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print ("delegate called")
    if selectedIndex == playResults.count - 1 {
      selectedIndex = -1
    }
    if flag == true && selectedIndex < playResults.count - 1{
      //Increment current index
      repeat {selectedIndex += 1
        if selectedIndex == playResults.count - 1 {
          selectedIndex = 0}
      } while self.playResults[selectedIndex].downloaded == false
      
      playMusic(selectedIndex: selectedIndex)
      
      nowPlaying = (audioPlayer?.isPlaying)!    }
    
     reloadTable()
  }
  
  func playMusic(selectedIndex:Int){
    
    for i in 0...playResults.count - 1 {
      playResults[i].isPlaying = false
    }
   
    //     playTableView.scrollToRow(at: nowPlayingIndexPath, at: .middle, animated: true)
    if  playResults[selectedIndex].downloaded {
      playResults[selectedIndex].isPlaying = true
      let url = localFilePath(for: playResults[selectedIndex].previewURL)
      try!  audioPlayer = AVAudioPlayer(contentsOf: url)
      audioPlayer?.delegate = self
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
      nowPlayingLabel.text =  "  재생중:  " + playResults[selectedIndex].firstLine
      nowPlayingLabel.textColor = .red
      nowPlaying = (audioPlayer?.isPlaying)!
      arrayOfButtons.remove(at: 4)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      reloadTable()
    
    }
    
  }
  
}


// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.

extension PlayViewController: PlayCellDelegate {
  
  func reload(_ row: Int) {
    playTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }
  
  
  func playTapped(_ cell: PlayCell) {
    
  }
  
  func stopTapped(_ cell: PlayCell) {
    
  }
  
 
 
}
  // Update track cell's buttons

  
  extension PlayViewController: AVAudioPlayerDelegate {
    
  
   
    
    
    
  }
  
extension CGRect{
  init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
    self.init(x:x,y:y,width:width,height:height)
  }
  
}
extension CGSize{
  init(_ width:CGFloat,_ height:CGFloat) {
    self.init(width:width,height:height)
  }
}
extension CGPoint{
  init(_ x:CGFloat,_ y:CGFloat) {
    self.init(x:x,y:y)
  }
}
