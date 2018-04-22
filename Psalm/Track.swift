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
  let whatIsThisIndex: Int
  let chapterIndex: Int
  var downloaded = true
  let firstLine: String
  var isPlaying = false
    let chapterContent: NSAttributedString
  
  init(name: String, artist: String, previewURL: URL, whatIsThisIndex: Int, chapterIndex: Int, firstLine: String, chapterContent: NSAttributedString)
  {
    self.name = name
    self.artist = artist
    self.firstLine = firstLine
    self.previewURL = previewURL
    self.whatIsThisIndex = whatIsThisIndex
    self.chapterIndex = chapterIndex
    self.chapterContent = chapterContent
  }
  
}
