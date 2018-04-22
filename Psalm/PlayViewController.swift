 //
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Jaisung NOH. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreGraphics
import MediaPlayer


class PlayViewController: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
  
  let commandCenter = MPRemoteCommandCenter.shared()
  let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
  
  var timer1 = Timer()
  var timer2 = Timer()
  var playTimeLabelTimer = Timer()
  var playingTime: Int = 0
  let infiniteSign = "\u{221E}"
  var headText = ""
  var firstLineExpanded = false
  
  var coll = Collected(collName: "", collArray: [])
 
    @IBOutlet weak var nowPlayingButton: UIButton!
    
    @IBOutlet weak var playToolBar: UIToolbar!
    
    @IBOutlet weak var touchLabel: UILabel!
    
  @IBOutlet weak var expandButton: UIButton!
    
  @IBAction func expandButtonPressed(_ sender:
    Any) {
  }
  
  @IBOutlet weak var timeElapsed: UILabel!
  
  @IBOutlet weak var timeRemaining: UILabel!
  
  @IBOutlet weak var musicProgressBar: UIProgressView!
  
  
  @IBOutlet weak var repeatButton: UIButton!
  var repeatChapter = false
  
  @IBAction func repeatButtonPressed(_ sender: UIButton) {
  //  print (nowPlayingInfoCenter.nowPlayingInfo!["selectedIndex"])
    
    if sender.titleLabel?.text == "전체반복" {
      sender.setTitle("장반복", for: .normal)
      repeatChapter = true
    }else {
      sender.setTitle("전체반복", for: .normal)
      repeatChapter = false      }
    
  }
  
  @IBOutlet weak var timeSegment: UISegmentedControl!
  
  @IBAction func timerButtonPressed(_ sender: UISegmentedControl) {
  
    
    
    
    switch  timeSegment.selectedSegmentIndex {
    case 0:
      
      timer1.invalidate()
      
      timer2.invalidate()
      UIView.transition(with: timerLabel, duration: 0.7, options: .transitionFlipFromLeft , animations: {self.timerLabel.text = "Timer"+"\n" + self.infiniteSign}, completion: nil)
    
      
      print ("0 pressed")
    case 1:
      
      runTimer(timeInterval: 1800)
      print ("1 selected")
      
    case 2:
      runTimer(timeInterval: 1800 * 2 )
      print ("2 selected ")
      
    case 3:
      runTimer(timeInterval: 1800 * 4 )
      print ("3  selected ")
      
    default:
      print ("deafult")
    }
    
    
    
  }
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var playTableView: UITableView!
  @IBOutlet weak var toolBar: UIToolbar!
  @IBOutlet var searchFooter: SearchFooter!
  @IBAction func showChapterButton(_ sender: Any) {
  }
 
  let searchController = UISearchController(searchResultsController: nil)
 
  @IBOutlet weak var nowPlayingLabel: UILabel!
  
  
  
    @IBAction func nowPlayingButton(_ sender: Any) {
     nowPlayingButtonPressed()
      
  }
      func nowPlayingButtonPressed() {
        audioPlayer?.delegate = self
      playResults = queryService.getSearchResults(coll: confirmedColl)
      self.title = confirmedColl.collName
       playtimeLabeling()
      updateLabel(trackFirstLine: playResults[confirmedIndex].firstLine )
   //   let myCell = playTableView.cellForRow(at: IndexPath(item: confirmedIndex, section: 0)) as! PlayCell
     let myCell = playTableView.dequeueReusableCell(withIdentifier: "playCell") as! PlayCell
      
      myCell.delegate = self
      
      let track: Track
      track = playResults[confirmedIndex]
      playResults[confirmedIndex].isPlaying = true
      myCell.configure(track: track)
 //   myCell.expandButton.titleLabel?.text = "확장"
        nowPlayingLabel.textColor = .red
       
       playingInfo(nowPlayingIndex: confirmedIndex)
        
        UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
//
    reloadTable(toMiddle: true)
//
    }
    
 
  
  
  var pauseButton = UIBarButtonItem()
  var playButton = UIBarButtonItem()
  var arrayOfButtons = [AnyObject]()
  
  var playResults: [Track] = []
  var justBeforePlayResults : [Track] = []
  let queryService = QueryService()
  let collectedService = CollectedService()
  var filteredTracks = [Track]()
  var chapterIndex = 0
 
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  

    

   
    timerLabel.text = "Timer"+"\n"+infiniteSign
    self.view.bringSubview(toFront: timerLabel)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "찾으시는 단어를 입력하세요"
   let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
    
    textFieldInsideSearchBar?.textColor = .white
    
    navigationItem.searchController = searchController
    definesPresentationContext = true
    //  searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
    searchController.searchBar.delegate = self
    playTableView.tableFooterView = searchFooter
   playTableView.setContentOffset(CGPoint.zero, animated: true)
 
    pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(pauseButtonTapped(sender:)))
    playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(playButtonTapped(sender: )))
    arrayOfButtons = self.toolBar.items!
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
   
    
    playResults = queryService.getSearchResults(coll: coll)
   
    let downloadedby =   searchViewController.checkDownloaded(results: playResults)
    print (downloadedby)
  
    playTableView.rowHeight = UITableViewAutomaticDimension
    playTableView.estimatedRowHeight = 300
   }
  

 
  
  
  
  override  func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(true)
    self.title = coll.collName
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = UIColor.clear
    
    commandCenter.previousTrackCommand.isEnabled = true
    commandCenter.nextTrackCommand.isEnabled = true
    commandCenter.playCommand.isEnabled = true
    commandCenter.pauseCommand.isEnabled = true
   commandCenter.skipBackwardCommand.isEnabled = false
    
    commandCenter.skipForwardCommand.isEnabled = false
    commandCenter.playCommand.addTarget(self, action: #selector(playButtonTapped(sender: )))
    commandCenter.previousTrackCommand.addTarget(self, action: #selector(rewindButtonTapped(sender: )))
    commandCenter.nextTrackCommand.addTarget(self, action: #selector(ffButtonTapped(sender: )))
    commandCenter.pauseCommand.addTarget(self, action: #selector(pauseButtonTapped(sender:)))

  
    
    setupNotifications()
    playtimeLabeling()
    nowPlayingLabel.text = nowPlayingFirstLine
    nowPlayingLabel.textColor = .red
    
    if repeatChapter == false {
      repeatButton.titleLabel?.text = "전체반복"
      
    }else {
      repeatButton.titleLabel?.text = "장반복"
          }
   
    arrayOfButtons.remove(at: 4)
    if audioPlayer != nil {
      
      if  (audioPlayer?.isPlaying)!  {
     arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      
   //  self.playResults[selectedIndex].isPlaying = true
     
    
    } else {
      arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
      
    }
   self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
     
     reloadTable(toMiddle: true)
    
    }
    else {
  
      arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
      
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      
      reloadTable(toMiddle: true)
      
      
//       playToolBar.isHidden = true
//      touchLabel.isHidden = false
//      nowPlayingButton.isHidden = true
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)

    commandCenter.previousTrackCommand.removeTarget(self)
//   commandCenter.pauseCommand.removeTarget(self)
   commandCenter.nextTrackCommand.removeTarget(self)
//    commandCenter.playCommand.removeTarget(self)


  }
  
  
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @objc  func playerChangedChapter(note:NSNotification) {
    

  }
  
  
  @IBAction func ffButtonPressed(_ sender: Any) {
    
//    playResults = queryService.getSearchResults(coll: confirmedColl)
//    self.title = confirmedColl.collName
    
    ffButtonTapped(sender: sender)

  }
  
  @objc func ffButtonTapped(sender: Any) {
 nowPlayingButtonPressed()
    
    if !isFiltering()   {
      
      if selectedIndex >= playResults.count - 1 {
        selectedIndex = -1
      }
      if selectedIndex < playResults.count - 1   {
        selectedIndex += 1
      
        confirmedIndex = selectedIndex
        playMusic(selectedIndex: selectedIndex)
       
        // pauseButtonTapped(sender: sender)
        nowPlaying = (audioPlayer?.isPlaying)!
    playingInfo(nowPlayingIndex: confirmedIndex)
      }
    }
    UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
    reloadTable(toMiddle: true)
  }
  
  
  @IBAction func rewindButtonPressed(_ sender: Any) {
 //   nowPlayingButtonPressed()
//    playResults = queryService.getSearchResults(coll: confirmedColl)
//    self.title = confirmedColl.collName
    rewindButtonTapped(sender: sender)

  }
  
  @objc func rewindButtonTapped(sender: Any) {
    nowPlayingButtonPressed()
    //  playResults = queryService.getSearchResults(coll: confirmedColl)
    self.title = confirmedColl.collName
    let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    if  !isFiltering() && noOfdownloaded  > 1  {
      if selectedIndex == -1 {
        selectedIndex = playResults.count - 1
      }
      
      if  audioPlayer != nil{
        //
        repeat {selectedIndex -= 1
          if selectedIndex == -1{
            selectedIndex = playResults.count - 1}
        } while self.playResults[selectedIndex].downloaded == false
        confirmedIndex = selectedIndex
        playMusic(selectedIndex: selectedIndex)
        
        //   pauseButtonTapped(sender: sender)
 
        playingInfo(nowPlayingIndex: confirmedIndex)
        
      }
    }
   UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
//
    reloadTable(toMiddle: true)
  }
  
  
  @objc  func playButtonTapped(sender: Any) {
   nowPlayingButtonPressed()
    let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    if audioPlayer != nil && noOfdownloaded  != 0 {
      audioPlayer?.play()
      playtimeLabeling()
      nowPlaying = (audioPlayer?.isPlaying)!
      arrayOfButtons.remove(at: 4)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
     
      playingInfo(nowPlayingIndex: confirmedIndex)
      
     
      
    } else {
      //selectedIndex = 0
      playMusic(selectedIndex: selectedIndex)
     
      
    }
   UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
    reloadTable(toMiddle: true)
  }
  
  @objc  func pauseButtonTapped(sender: Any) {
    nowPlayingButtonPressed()
    playTimeLabelTimer.invalidate()
    audioPlayer?.pause()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
    playingInfo(nowPlayingIndex: confirmedIndex)
    
    UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
    reloadTable(toMiddle: true)
  }
  
  func playingInfo(nowPlayingIndex: Int){
   
//   let nowPlayingIndexx = playResults[confirmedIndex].chapterIndex

    let image1 = UIImage(named: "ItunesArtwork")!
    let artworkProperty = MPMediaItemArtwork.init(boundsSize: image1.size, requestHandler: { (size) -> UIImage in return image1 })
   let nowPlayingInfo: [String: Any]
   // var nowPlayResults = queryService.getSearchResults(coll: confirmedColl)
    nowPlayingInfo = [
      MPMediaItemPropertyArtwork: artworkProperty,
      MPMediaItemPropertyArtist: playResults[nowPlayingIndex].name ,
      MPMediaItemPropertyTitle: playResults[nowPlayingIndex].firstLine,
      MPMediaItemPropertyPlaybackDuration: audioPlayer?.duration as Any,
       MPNowPlayingInfoPropertyPlaybackRate: 1.0,
      MPNowPlayingInfoPropertyElapsedPlaybackTime: audioPlayer?.currentTime as Any
    ]
    
    
    
    nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    
    
  }
  
  
  
  
  //}
  //// MARK: - UITableView
  //
  //extension PlayViewController: UITableViewDataSource, UITableViewDelegate {
  //
  
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredTracks.count, of: playResults.count)
      return filteredTracks.count
    }
    searchFooter.setNotFiltering()
    
    return playResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //  let cell: PlayCell = playTableView.dequeueReusableCell(for: indexPath)
    let cell = playTableView.dequeueReusableCell(withIdentifier: "playCell") as! PlayCell
    // Delegate cell button tap events to this view controller
    cell.delegate = self
    let track: Track
   
    if isFiltering() {
      track = filteredTracks[indexPath.row]
    } else {
      track = playResults[indexPath.row]
    }
    cell.configure(track: track)
   return cell
  }
  
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  // When user taps cell, play the local file, if it's downloaded
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    nowPlayingButton.isHidden = false
    playToolBar.isHidden = false
    touchLabel.isHidden = true
    if confirmedColl.collName != coll.collName || indexPath.row != confirmedIndex {
    
    confirmedColl = coll
    confirmedIndex = indexPath.row
    
     playResults = queryService.getSearchResults(coll: confirmedColl)
    }
//    print (confirmedIndex)
  
    let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    
    if noOfdownloaded != 0 {
      
      if isFiltering() {
        let   track = filteredTracks[indexPath.row]
        selectedIndex = track.whatIsThisIndex
        chapterIndex = track.chapterIndex
     //   confirmedIndex = chapterIndex
       
        
      } else {
        let  track = playResults[indexPath.row]
        selectedIndex = track.whatIsThisIndex
        chapterIndex = track.chapterIndex
     
      }
  
      if  playResults[selectedIndex].downloaded == true {
        playResults[selectedIndex].isPlaying = true
        
        playMusic(selectedIndex: selectedIndex)
        playingInfo(nowPlayingIndex: selectedIndex)

        arrayOfButtons.remove(at: 4)
        arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
        self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
        //  playTableView.reloadData()//
        
        if self.searchController.isActive == true {
          self.searchController.isActive = false
          UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
          playTableView.beginUpdates()
          playTableView.endUpdates()
          
          reloadTable(toMiddle: true)
          
        }else {
          
          if firstLineExpanded  {
          UIView.transition(with: playTableView, duration: 0.5, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
          reloadTable(toMiddle: true)
          firstLineExpanded = false
          
          
          } else {
            UIView.transition(with: playTableView, duration: 0.1, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
           reloadTable(toMiddle: false)
            firstLineExpanded = false
          
          }
            
          }
        
      } else {
        let arrayOfDownloaded =  playResults.filter{ $0.downloaded }
        let firstIndexOfDownloadedTrack = arrayOfDownloaded[0].whatIsThisIndex
        
        selectedIndex = justBeforeSelectedIndex == -1 ? firstIndexOfDownloadedTrack : justBeforeSelectedIndex
        playResults[selectedIndex].isPlaying = true
        connectionAlert(title: "설치필요", message: "설치메뉴로 돌아가 재설치후 재생하십시오")
        
      }
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = UIColor.lightGray
    let myLabel: UILabel = UILabel(frame: CGRect(8,0,200,30))
    myLabel.textColor = .white
    myLabel.textAlignment = NSTextAlignment.left
    myLabel.text = headText
    header.addSubview(myLabel)
    
    return header
  }
  
  
  func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
  
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    
    
    if flag == true && repeatChapter == true {
      playMusic(selectedIndex: selectedIndex)
      
      nowPlaying = (audioPlayer?.isPlaying)!
      
    }else {
      let noOfdownloaded = playResults.filter{ $0.downloaded }.count
      if noOfdownloaded  > 1 {
        if confirmedIndex == playResults.count  {
          confirmedIndex = 0
        }
        
        
        if flag == true && confirmedIndex < playResults.count {
          //Increment current index
          repeat {confirmedIndex += 1
            if confirmedIndex == playResults.count {
              confirmedIndex = 0}
          } while self.playResults[confirmedIndex].downloaded == false
          selectedIndex = confirmedIndex
          playMusic(selectedIndex: confirmedIndex)
          
          nowPlaying = (audioPlayer?.isPlaying)!
          
        }
        
      }
    }
 
    
    playingInfo(nowPlayingIndex: confirmedIndex)
    
    UIView.transition(with: playTableView, duration: 0.7, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)


    reloadTable(toMiddle: true)
    
  }
  
  
  
  func playMusic(selectedIndex:Int){

   
    for i in 0...playResults.count - 1 {
      playResults[i].isPlaying = false
    }
    
//        playTableView.scrollToRow(at: nowPlayingIndexPath, at: .middle, animated: true)
    if  selectedIndex != -1 && playResults[selectedIndex].downloaded  {
      
      playResults[selectedIndex].isPlaying = true
      
      let url = localFilePath(for: playResults[selectedIndex].previewURL)
      try!  audioPlayer = AVAudioPlayer(contentsOf: url)
      audioPlayer?.delegate = self
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
       playingInfo(nowPlayingIndex: confirmedIndex)
      playtimeLabeling()
    
      nowPlayingLabel.textColor = .red
      nowPlaying = (audioPlayer?.isPlaying)!
      arrayOfButtons.remove(at: 4)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      
      
    }
    
  }
  
  
  
  
  func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//    let  collectedResults = collectedService.getCollected()
//    let playResults = queryService.getSearchResults(coll: collectedResults[0])
//
    
    filteredTracks = playResults.filter({( track : Track) -> Bool in
      let doesCategoryMatch = (scope == "All") // || (candy.category == scope)
      
      if searchBarIsEmpty() {
        return doesCategoryMatch
      } else {
        return doesCategoryMatch && track.chapterContent.string.contains(searchText.lowercased())
      }
    })
    playTableView.reloadData()
  }
  
  
  func isFiltering() -> Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
  }
  
}


// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.

extension PlayViewController: PlayCellDelegate {
  
  func reload(_ row: Int) {
    playTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }
  
  
  func playTapped(_ cell: PlayCell) {
    
  }
  
  func expandFirstline(_ cell: PlayCell, onOrOff: Bool) {
    if onOrOff {
    cell.firstLineLabel.text = playResults[selectedIndex].chapterContent.string
      playTableView.beginUpdates()
      playTableView.endUpdates()
      firstLineExpanded = true
      
    } else {
     cell.firstLineLabel.text = playResults[selectedIndex].firstLine
      playTableView.beginUpdates()
      playTableView.endUpdates()
      firstLineExpanded = false
      
      UIView.transition(with: playTableView, duration: 0.4, options: .transitionCrossDissolve , animations: {self.playTableView.reloadData()}, completion: nil)
     
    }
  }
  
  
  
  func stopTapped(_ cell: PlayCell) {
    
  }
  
  func updateLabel(trackFirstLine: String) {
    nowPlayingLabel.text =   trackFirstLine
    nowPlayingFirstLine = trackFirstLine

  }
 
  
  
}
// Update track cell's buttons

extension PlayViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
 
  }
}

extension PlayViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  
  func updateSearchResults(for searchController: UISearchController) {
    _ = searchController.searchBar
    //  let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: "All")
  }
}

extension PlayViewController: ReadChapterViewControllerDelegate {
  
 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewControllerB = segue.destination as? ReadChapterViewController {
      if selectedIndex != -1 {
       
        let playingResults = queryService.getSearchResults(coll: confirmedColl)
   //     print(confirmedColl.collName)
   //     chapter = playingResults[selectedIndex].chapterIndex
        
        
 //       print (chapter)
 //       print (confirmedIndex)
        viewControllerB.playingResults = playingResults
        
        //chapterIndex = chapter
        viewControllerB.delegate = self
      }
    }
  }
  
  func textChanged(text: NSAttributedString) {
    // text =  playResults[selectedIndex].chapter
    
  }
  
  
  
  
}



extension PlayViewController: AVAudioPlayerDelegate {
  
}

extension CGRect{
  init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
    self.init(x:x,y:y,width:width,height:height)
  }
  
}
extension CGSize{
  init(_ width:CGFloat,_ height:CGFloat) {
    self.init(width:width,height:height)
  }
}
extension CGPoint{
  init(_ x:CGFloat,_ y:CGFloat) {
    self.init(x:x,y:y)
  }
}
