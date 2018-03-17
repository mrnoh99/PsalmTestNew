

import Foundation
import UIKit

extension SearchViewController {
  
  func connectionAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
  }
}

extension PlayViewController {
  
  
  
  
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
    
    self.timerLabel.text = "Timer"+"\n"+timeString(time: TimeInterval(playingTime)) //This will update the label.
  }
  
  func timeString(time:TimeInterval) -> String {
    let hour    = Int(time) / 3600
    let minutes = hour * 60 + Int(time) / 60 % 60 
    let seconds = Int(time) % 60
    return String(format:"%03i:%02i",minutes, seconds)
    
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
  
  
}









    


