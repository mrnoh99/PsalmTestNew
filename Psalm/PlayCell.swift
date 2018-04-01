//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit

protocol PlayCellDelegate {
  
  func playTapped(_ cell: PlayCell)
  func stopTapped(_ cell: PlayCell)
  func updateLabel(trackFirstLine: String)
  func expandFirstline(_ cell: PlayCell, onOrOff: Bool)
}

class PlayCell: UITableViewCell {
 
  var delegate: PlayCellDelegate?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var firstLineLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
 @IBOutlet weak var downloaded: UILabel!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBAction func expandButtonPressed(_ sender: Any) {
      if self.expandButton.currentTitle == "확장" {
        self.expandButton.setTitle("축소",for: .normal)
        delegate?.expandFirstline(self, onOrOff: true)
        
      } else {
        self.expandButton.setTitle("확장",for: .normal)
       delegate?.expandFirstline(self, onOrOff: false)
        }
      }
  
    @IBAction func readChapter(_ sender: UIButton) {
    }
    
    
  @IBAction func playTapped(_ sender: AnyObject) {
    delegate?.playTapped(self)
  }
  
  @IBAction func stopTapped(_ sender: AnyObject) {
    delegate?.stopTapped(self)
  }
  
  
  func configure(track: Track) {
    titleLabel.text = track.name
    titleLabel.font = UIFont.systemFont(ofSize: titleLabel.font.pointSize)
    firstLineLabel.text = track.firstLine
     progressLabel.isHidden = true
    downloaded.isHidden = true
    expandButton.isHidden = true
    
    
    //     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if track.isPlaying {
      expandButton.isHidden = false
      progressLabel.isHidden = false
     progressLabel.text = "재생중..."
     titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
      // firstLineLabel.text = track.chapter.string
      
      
      DispatchQueue.main.async {
        print ("dispatch performed")
      self.delegate?.updateLabel(trackFirstLine: track.firstLine)
     
      }
     
    }
    if !track.downloaded {
      downloaded.isHidden = false}
      
      selectionStyle = track.downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
//    downloadButton.isHidden = downloaded || showDownloadControls
   
  }
  
  
  func updateDisplay(progress: Float, totalSize : String) {
    progressView.progress = progress
    progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
  }
  
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
