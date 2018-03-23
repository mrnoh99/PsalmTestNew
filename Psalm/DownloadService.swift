//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

  // SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  var activeDownloads: [URL: Download] = [:]

  // MARK: - Download methods called by TrackCell delegate methods

  func startDownload(_ track: Track) {
    // 1
    let fileName = track.artist
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationFileUrl = documentsPath.appendingPathComponent(fileName)
    
    if  !FileManager.default.fileExists(atPath: destinationFileUrl.path) {
      let download = Download(track: track)
    // 2
  
    download.task = downloadsSession.downloadTask(with:  track.previewURL)
    
    download.task!.resume()
    // 4
    download.isDownloading = true
    // 5
    activeDownloads[download.track.previewURL] = download
  }
  }

 
  func cancelDownload(_ track: Track) {
    if let download = activeDownloads[track.previewURL] {
      download.task?.cancel()
      activeDownloads[track.previewURL] = nil
    }
  }

 

  
  
}
