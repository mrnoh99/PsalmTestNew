//
//  Play.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class Play {
  
  var track: Track
  init(track: Track) {
    self.track = track
  }
  
  var isPlaying = false
  
 
  
  // Download delegate sets this value:
  var progress: Float = 0
  
}



