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
  
  var nowPlayingRow = 0 {
    didSet {
        nowPlayingLabel.text = playResults[nowPlayingRow].firstLine
        
    }
  }
  
  var nowPlaying = false {
    didSet {
      if nowPlaying {
        arrayOfButtons = self.toolBar.items!
        arrayOfButtons.remove(at: 4) // change index to correspond to where your button is
      
        arrayOfButtons.insert(pauseButton, at: 4)
      
        self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
        
      } else {
        arrayOfButtons = self.toolBar.items!
        arrayOfButtons.remove(at: 4) // change index to correspond to where your button is
        
        arrayOfButtons.insert(playButton, at: 4)
        
        self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      }
      
  }
  }
  
  var  audioPlayer: AVAudioPlayer? {
    get {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate.audioPlayer
    }
    set {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.audioPlayer = newValue
    }
  }
  
  
  
  
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(pauseButtonTapped(sender:)))
      playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(playButtonTapped(sender: )))
      arrayOfButtons = self.toolBar.items!
      
       arrayOfButtons.remove(at: 4)
     arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
     self.toolBar.setItems(arrayOfButtons as! [UIBarButtonItem], animated: false)

    
      
      
        
        
        
      do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        print ("playbackOK")
        try AVAudioSession.sharedInstance().setActive(true)
        print("session is active")
      }catch let error {
        print(error.localizedDescription)
      }
    
      playResults = queryService.getSearchResults()
      searchViewController.checkDownloaded(results: playResults)
      
       playTableView.tableFooterView = UIView()
      
      playTableView.reloadData()
      playTableView.setContentOffset(CGPoint.zero, animated: false)
      // Do any additional setup after loading the view.
      
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(playerChangedChapter(note:)),
        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
        object: nil)
      
      
  }
  
      
  override  func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(true)
    
           }
 

   
      
    
    
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @objc  func playerChangedChapter(note:NSNotification) {
    nowPlayingRow = nowPlayingRow + 1
    
  }
  
  @objc  func playButtonTapped(sender: Any) {
  print ("playpressed")
    nowPlaying = true

    qplayer?.play()
  }
  
  @objc  func pauseButtonTapped(sender: Any) {
  print("pausedPressed")
    nowPlaying = false
    qplayer?.pause()

  }
  
 
  func makePlayingCassette(selectedIndexPath:IndexPath) -> (AVQueuePlayer)  {
    
    searchViewController.checkDownloaded(results: playResults)
    let quePlayer = AVQueuePlayer()
    let selectedRow = selectedIndexPath.row
       nowPlayingRow = selectedRow
    if selectedRow == 0 {
      for selectedRow in 0...queryService.numberOfChapters - 1 {
        if  playResults[selectedRow].downloaded {
          let url = localFilePath(for: playResults[selectedRow].previewURL)
          let playerItem = AVPlayerItem(url:url)
          quePlayer.insert(playerItem, after:nil)
        }
      } } else {
        
    
    for selectedRow in selectedRow...queryService.numberOfChapters - 1 {
      if  playResults[selectedRow].downloaded {
      let url = localFilePath(for: playResults[selectedRow].previewURL)
    let playerItem = AVPlayerItem(url:url)
        quePlayer.insert(playerItem, after:nil)
      } }
      for selectedRow in 0...selectedRow - 1 {
        if  playResults[selectedRow].downloaded {
          let url = localFilePath(for: playResults[selectedRow].previewURL)
          let playerItem = AVPlayerItem(url:url)
          quePlayer.insert(playerItem, after:nil)
        }
      } }
    return quePlayer
      
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
     nowPlaying = true
    let track = playResults[indexPath.row]
    
    if track.downloaded {
      qplayer = makePlayingCassette(selectedIndexPath: indexPath)
       playCassette()
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.

extension PlayViewController: PlayCellDelegate {
  
  func playTapped(_ cell: PlayCell) {
    
  }
  
  func stopTapped(_ cell: PlayCell) {
    
  }
  
  // Update track cell's buttons
  func reload(_ row: Int) {
   playTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }
  
  
//  func checkDownloaded(results: [Track])-> Int  {
//    var j = 0
//    for i in 0...queryService.numberOfChapters - 1{
//
//      let fileName = results[i].artist
//      let destinationFileUrl = documentsPath.appendingPathComponent(fileName)
//      if  FileManager.default.fileExists(atPath: destinationFileUrl.path) {
//        results[i].downloaded = true
//        reload(i)
//        j += 1
//      }
//
//    }
//    return j
//  }

}

  
  extension PlayViewController: AVAudioPlayerDelegate {
    
    func playCassette(){
    
      if qplayer?.rate != 0 {
        qplayer?.pause()
      }
      qplayer?.play()
    }
    
    
    private func audioPlayerDidFinishPlaying(_ player: AVQueuePlayer, successfully flag: Bool) {
      print("did finishig palying called")
      nowPlaying = false
      
    }
    
    
    
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
