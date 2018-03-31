//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

extension SearchViewController {
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func availableDiskSpace()-> Int64?  {
    
    let fileURL:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
    
    do {
      let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
      if let capacity = values.volumeAvailableCapacityForImportantUsage {
        print("Available capacity for important usage: \(capacity / 1048567 ) Mega")
        return capacity / 1048567 //1073741824 //1048567
      } else {
        
        print("Capacity is unavailable")
        return nil
      }
    } catch {
      print("Error retrieving capacity: \(error.localizedDescription)")
      return nil
    }
    
  }
  
  func usedSpace()-> Int{
    // get your directory url
    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // check if the url is a directory
    var  folderSize = 0
    if (try? documentsDirectoryURL.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
      folderSize = 0
      (FileManager.default.enumerator(at: documentsDirectoryURL, includingPropertiesForKeys: nil)?.allObjects as? [URL])?.lazy.forEach {
        folderSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
      }
      let  byteCountFormatter =  ByteCountFormatter()
      byteCountFormatter.allowedUnits = .useBytes
      byteCountFormatter.countStyle = .file
      let sizeToDisplay = byteCountFormatter.string(for: folderSize) ?? ""
     // print(sizeToDisplay)  // "X,XXX,XXX bytes"
      
      
    }
    return Int(folderSize / 1048567)   //1073741824 //1048567}
    
  }

  
  
}
  

extension PlayViewController {
  func setupNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(handleInterruption),
                                   name: .AVAudioSessionInterruption,
                                   object: nil)
  }
  
  @objc   func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
        return
    }
    if type == .began {
      // Interruption began, take appropriate actions
      if audioPlayer != nil {
        playTimeLabelTimer.invalidate()
        audioPlayer?.pause()
        nowPlaying = (audioPlayer?.isPlaying)!
        arrayOfButtons.remove(at: 4)
        arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
        self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
        playingInfo(selectedIndex: selectedIndex)
      }
    }
    else if type == .ended {
      if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
        let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
        if options.contains(.shouldResume) {
          
          // Interruption Ended - playback should resume
          
          
          if audioPlayer != nil  {
            audioPlayer?.play()
            playtimeLabeling()
            nowPlaying = (audioPlayer?.isPlaying)!
            arrayOfButtons.remove(at: 4)
            arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
            self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
            
            playingInfo(selectedIndex: selectedIndex)
            
          }
          
          reloadTable(toMiddle: true)
          
          
          
        } else {
          // Interruption Ended - playback should NOT resume
          if audioPlayer != nil {
            playTimeLabelTimer.invalidate()
            audioPlayer?.stop()
            nowPlaying = (audioPlayer?.isPlaying)!
            arrayOfButtons.remove(at: 4)
            arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
            self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
            playingInfo(selectedIndex: selectedIndex)
          }
        }
      }
    }
  }
  
  
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func reloadTable(toMiddle: Bool){
   self.searchController.isActive = false
    if selectedIndex != -1 {
    let nowPlayingIndexPath = IndexPath(item: selectedIndex, section: 0)
    self.playTableView.reloadData()
      if toMiddle == true {
      self.playTableView.scrollToRow(at: nowPlayingIndexPath, at: .middle, animated: false)
      }
    }
  }
  
  
  
  func runTimer(timeInterval: Int ) {
    timer1.invalidate()
    timer2.invalidate()
    self.playingTime = timeInterval
     self.timerLabel.isHidden = false
    self.timerLabel.textColor = .red
    timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
     timer2 = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(stopPlayer), userInfo: nil, repeats: false)
  
    
    
  }
  
  @objc func updateTimer() {
     playingTime -= 1
    let labelText = "Timer"+"\n"+timeString(time: TimeInterval(playingTime), select: 1 ) //This will update the label.
    UIView.transition(with: timerLabel, duration: 0.7, options: .transitionFlipFromLeft , animations: {self.timerLabel.text = labelText}, completion: nil)
   
 
  }
  
  func timeString(time:TimeInterval,select: Int) -> String {
    let hour    = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    if select == 1{
      return String(format:"%01i:%02i:%02i",hour,minutes, seconds)
    } else {
       return String(format:"%02i:%02i",minutes, seconds)
      
    }
  }
@objc func stopPlayer(){
  timer1.invalidate()
  timer2.invalidate()
  self.timerLabel.text = infiniteSign
  if audioPlayer != nil {
    audioPlayer?.pause()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
    self.timeSegment.selectedSegmentIndex =  UISegmentedControlNoSegment
  }
    
  }
  
  func playtimeLabeling () {
  
  self.playTimeLabelTimer.invalidate()
  self.playTimeLabelTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(timeStapm), userInfo: nil, repeats: true)
  
  }
  
  
  @objc    func timeStapm () {
    
    if audioPlayer != nil && (audioPlayer?.isPlaying)! {
      let elapsedTime = TimeInterval((audioPlayer!.currentTime))
      let remainingTime = TimeInterval( (audioPlayer!.duration))
  //  let durationTimeInsec = CMTimeGetSeconds( (audioPlayer!.duration)!)
    
    
//    guard !(elapsedTimeInSecond.isNaN || remainingTimeInSec1.isNaN) else {return}
//
//    let   elapsedTimeStringMin =  Int(elapsedTimeInSecond / 60)
//    let elapsedTimeStringSec =  Int(elapsedTimeInSecond) % 60
//    let elapsedTimeString = "\(elapsedTimeStringMin)"+":"+"\(elapsedTimeStringSec)"
//
//    let   remainingTimeInSec =  remainingTimeInSec1  // -  elapsedTimeInSecond
//    let remainingTimeStringMin =  Int(remainingTimeInSec) / 60
//    let remainingTimeStringSec =  Int(remainingTimeInSec) % 60
//    let remainingTimeString = "\(remainingTimeStringMin)"+":"+"\(remainingTimeStringSec)"
    
      self.timeElapsed.text = timeString(time: elapsedTime, select: 2)
      self.timeRemaining.text = timeString(time: remainingTime, select: 2)
    self.musicProgressBar.progress = Float(elapsedTime / remainingTime)
    
    }
  }
  
  
  
}





    


