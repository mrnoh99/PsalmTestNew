//
//  Singleton.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 8..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import Foundation
import AVFoundation

class Singleton {
  static let sharedInstance = Singleton()
  private var player: AVAudioPlayer?
  
  func play() {
    guard let url = Bundle.main.url(forResource: "Sound", withExtension: "mp3") else { return }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      
      guard let player = player else { return }
      
      player.play()
      
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  func stop() {
    player?.stop()
  }
}
