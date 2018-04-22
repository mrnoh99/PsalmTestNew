//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.

import UIKit

protocol TrackCellDelegate {
//  func pauseTapped(_ cell: TrackCell)
//  func resumeTapped(_ cell: TrackCell)
  func cancelTapped(_ cell: TrackCell)
  func downloadTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {

  // Delegate identifies track for this cell,
  // then passes this to a download service method.
  var delegate: TrackCellDelegate?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var firstLineLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var downloadButton: UIButton!
  
//  @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
//    if(pauseButton.titleLabel!.text == "Pause") {
//      delegate?.pauseTapped(self)
//    } else {
//      delegate?.resumeTapped(self)
//    }
//  }
//
  @IBAction func cancelTapped(_ sender: AnyObject) {
    delegate?.cancelTapped(self)
  }
  
  @IBAction func downloadTapped(_ sender: AnyObject) {
    delegate?.downloadTapped(self)
  }
  
  func configure(track: Track, downloaded: Bool, download: Download?) {
    titleLabel.text = track.name
    firstLineLabel.text = track.firstLine

    // Download controls are Pause/Resume, Cancel buttons, progress info
    var showDownloadControls = false
    // Non-nil Download object means a download is in progress
    if let download = download {
      showDownloadControls = true      
   //   let title = download.isDownloading ? "중단" : "다시시작"
   //   pauseButton.setTitle(title, for: .normal)
      progressLabel.text = download.isDownloading ? "설치중..." : "설치중단"
    }

 //   pauseButton.isHidden = !showDownloadControls
    cancelButton.isHidden = !showDownloadControls
    progressView.isHidden = !showDownloadControls
    progressLabel.isHidden = !showDownloadControls
    
    // If the track is already downloaded, enable cell selection and hide the Download button
    selectionStyle =   UITableViewCellSelectionStyle.none
    downloadButton.isHidden = downloaded || showDownloadControls
  }

  func updateDisplay(progress: Float, totalSize : String) {
    progressView.progress = progress
    progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
  }

}
