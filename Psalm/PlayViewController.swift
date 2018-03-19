//
//  PlayViewController.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 3. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreGraphics


class PlayViewController: UIViewController, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
  var timer1 = Timer()
  var timer2 = Timer()
  var playTimeLabelTimer = Timer()
  var playingTime: Int = 0
  let infiniteSign = "\u{221E}"
  
    @IBOutlet weak var timeElapsed: UILabel!
    
    @IBOutlet weak var timeRemaining: UILabel!
    
    @IBOutlet weak var musicProgressBar: UIProgressView!
    
  
  @IBOutlet weak var repeatButton: UIButton!
    var repeatChapter = true
  
    @IBAction func repeatButtonPressed(_ sender: UIButton) {
      if sender.titleLabel?.text == "전체반복" {
        sender.setTitle("장반복", for: .normal)
        repeatChapter = false
      }else {
        sender.setTitle("전체반복", for: .normal)
        repeatChapter = true      }
      
    }
    
  @IBOutlet weak var timeSegment: UISegmentedControl!
  
    @IBAction func timerButtonPressed(_ sender: UISegmentedControl) {
     
    switch  timeSegment.selectedSegmentIndex {
    case 0:
      
      timer1.invalidate()
      
      timer2.invalidate()
      timerLabel.text = infiniteSign
      
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
    
//  var detailViewController: DetailViewController? = nil

   let searchController = UISearchController(searchResultsController: nil)
  
//
//    lazy var tapRecognizer: UITapGestureRecognizer = {
//    var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
//    return recognizer
//  }()
  
  @IBOutlet weak var nowPlayingLabel: UILabel!
    
//  var playingLabelText: String = "" {
//    didSet {
//     nowPlayingLabel.text = loadedTrack    // playResults[selectedIndex].firstLine
//
//
//    }
//  }
  
  
  
   var pauseButton = UIBarButtonItem()
    var playButton = UIBarButtonItem()
    var arrayOfButtons = [AnyObject]()
  
    var playResults: [Track] = []
     let queryService = QueryService()
     var filteredTracks = [Track]()
 

  
  
  
  
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       timerLabel.text = infiniteSign
      self.view.bringSubview(toFront: timerLabel)
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "찾으시는 단어를 입력하세요"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    //  searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
      searchController.searchBar.delegate = self
      playTableView.tableFooterView = searchFooter
      
      do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
     
        try AVAudioSession.sharedInstance().setActive(true)
       
      }catch let error {
        print(error.localizedDescription)
      }
    
  
      
      pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(pauseButtonTapped(sender:)))
      playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(playButtonTapped(sender: )))
      arrayOfButtons = self.toolBar.items!
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      
      playResults = queryService.getSearchResults()
      searchViewController.checkDownloaded(results: playResults)
      

      
  }
  
      
  override  func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(true)
   
  // print (loadedrow[0].firstLine)
  //  timerLabel.isHidden = true
    arrayOfButtons.remove(at: 4)
    
    if nowPlaying  {
     
     
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
    } else {
      arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
     
    }
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
   
 reloadTable(toMiddle: true)
    
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @objc  func playerChangedChapter(note:NSNotification) {
   
    
  }
  
    
  @IBAction func ffButtonPressed(_ sender: UIBarButtonItem) {
    let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    print (noOfdownloaded)
    if !isFiltering() && noOfdownloaded  > 1 {
      
       if selectedIndex == playResults.count - 1 {
        selectedIndex = -1
      }
      if selectedIndex < playResults.count - 1   {
        //Increment current index
        repeat {selectedIndex += 1
          if selectedIndex == playResults.count {
            selectedIndex = 0}
        } while self.playResults[selectedIndex].downloaded == false
        
        playMusic(selectedIndex: selectedIndex)
        
        nowPlaying = (audioPlayer?.isPlaying)!
        
      }
  }
     reloadTable(toMiddle: true)
  }
    
  
  
    
  @IBAction func rewindButtonPressed(_ sender: UIBarButtonItem) {
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
      
      playMusic(selectedIndex: selectedIndex)
    }
    }
    reloadTable(toMiddle: true)
  }
  
    
    
    
  @objc  func playButtonTapped(sender: Any) {
 let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    if audioPlayer != nil && noOfdownloaded  != 0 {
    audioPlayer?.play()
      playtimeLabeling()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
      
  
    } else {
      selectedIndex = 0
      playMusic(selectedIndex: selectedIndex)
    }
    reloadTable(toMiddle: true)
  }
  
  @objc  func pauseButtonTapped(sender: Any) {
 let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    
    if audioPlayer != nil && noOfdownloaded  != 0 {
      playTimeLabelTimer.invalidate()
      audioPlayer?.pause()
    nowPlaying = (audioPlayer?.isPlaying)!
    arrayOfButtons.remove(at: 4)
    arrayOfButtons.insert(playButton, at: 4) // change index to wherever you'd like the button
    self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)

      
    }
    reloadTable(toMiddle: true)
    
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
    return 62.0
  }
  
  // When user taps cell, play the local file, if it's downloaded
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if isFiltering() {
      let   track = filteredTracks[indexPath.row]
      selectedIndex = track.index
     
   //   track = playResults[indexPath.row]
       //  playTableView.reloadData()
      
    } else {
     let  track = playResults[indexPath.row]
      selectedIndex = track.index
    }
    
    
    
    if  playResults[selectedIndex].downloaded == true {
      
      playResults[selectedIndex].isPlaying = true
      
      playMusic(selectedIndex: selectedIndex)
   
      arrayOfButtons.remove(at: 4)
      arrayOfButtons.insert(pauseButton, at: 4) // change index to wherever you'd like the button
      self.toolBar.setItems(arrayOfButtons as? [UIBarButtonItem], animated: false)
   //  playTableView.reloadData()//
     
      if self.searchController.isActive == true {
        self.searchController.isActive = false
         reloadTable(toMiddle: true)
        
      }else {
         reloadTable(toMiddle: false)      }
      
      
     
     
    } else {
      
      selectedIndex = justBeforeSelectedIndex
      playResults[selectedIndex].isPlaying = true
      connectionAlert(title: "설치필요", message: "설치메뉴로 돌아가 재설치후 재생하십시오")
      
    }
  }
  
    
  

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    let noOfdownloaded = playResults.filter{ $0.downloaded }.count
    
    if flag == true && repeatChapter == true {
      playMusic(selectedIndex: selectedIndex)
      
      nowPlaying = (audioPlayer?.isPlaying)!
      
    }else {
    
    if noOfdownloaded  > 1 {
    if selectedIndex == playResults.count - 1 {
      selectedIndex = -1
    }
      
        
    if flag == true && selectedIndex < playResults.count - 1{
      //Increment current index
      repeat {selectedIndex += 1
        if selectedIndex == playResults.count - 1 {
          selectedIndex = 0}
      } while self.playResults[selectedIndex].downloaded == false
      
      playMusic(selectedIndex: selectedIndex)
      
      nowPlaying = (audioPlayer?.isPlaying)!
      
    }
        
      }
    }
    reloadTable(toMiddle: true)
  
}
  func playMusic(selectedIndex:Int){
    
    for i in 0...playResults.count - 1 {
      playResults[i].isPlaying = false
    }
   
    //     playTableView.scrollToRow(at: nowPlayingIndexPath, at: .middle, animated: true)
    if  playResults[selectedIndex].downloaded {
      playResults[selectedIndex].isPlaying = true
      let url = localFilePath(for: playResults[selectedIndex].previewURL)
      try!  audioPlayer = AVAudioPlayer(contentsOf: url)
      audioPlayer?.delegate = self
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
      playtimeLabeling()
    //  self.nowPlayingLabel.text =  "  재생중:  " + playResults[selectedIndex].firstLine
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
    filteredTracks = playResults.filter({( track : Track) -> Bool in
      let doesCategoryMatch = (scope == "All") // || (candy.category == scope)
      
      if searchBarIsEmpty() {
        return doesCategoryMatch
      } else {
        return doesCategoryMatch && track.firstLine.contains(searchText.lowercased())
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
  
  func stopTapped(_ cell: PlayCell) {
    
  }
  
  func updateLabel(trackFirstLine: String) {
    nowPlayingLabel.text =  "재생중:  " + trackFirstLine
    
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
      viewControllerB.text = playResults[selectedIndex].firstLine
      viewControllerB.delegate = self
      }
    }
  }
  
  func textChanged(text: String) {
   // text =  playResults[selectedIndex].firstLine
    
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
