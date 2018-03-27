//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import Foundation.NSURL

// Query service creates Track objects
class Track {

  let name: String
  let artist: String
  let previewURL: URL
  let index: Int
  var downloaded = false
  let firstLine: String
  var isPlaying = false
    let chapter: String
  
  init(name: String, artist: String, previewURL: URL, index: Int, firstLine: String, chapter: String) {
    self.name = name
    self.artist = artist
    self.firstLine = firstLine
    self.previewURL = previewURL
    self.index = index
    self.chapter = chapter 
  }
  
}
