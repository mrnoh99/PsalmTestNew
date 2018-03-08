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


class PlayViewController: UIViewController {

    @IBOutlet weak var playTableView: UITableView!
  
  
 
  var playResults: [Track] = []
  let queryService = QueryService()
 
  var  qplayer: AVQueuePlayer? {
    get {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate.qplayer
    }
    set {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.qplayer = newValue
    }
  }
  
  
  
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
      playResults = queryService.getSearchResults()
      searchViewController.checkDownloaded(results: playResults)
      
       playTableView.tableFooterView = UIView()
      
      playTableView.reloadData()
      playTableView.setContentOffset(CGPoint.zero, animated: false)
      // Do any additional setup after loading the view.
      
      
      }
      
  override  func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(true)
    
           }
 

   
      
    
    
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
 
  
 
  func makePlayingCassette(selectedIndexPath:IndexPath) -> (AVQueuePlayer)  {
    
    searchViewController.checkDownloaded(results: playResults)
    let quePlayer = AVQueuePlayer()
    let selectedRow = selectedIndexPath.row
    
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
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    
      
    }
    
    
    
  }
  

