


import UIKit
import AVKit
import AVFoundation


class SearchViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  
  //  lazy var tapRecognizer: UITapGestureRecognizer = {
  //    var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
  //    return recognizer
  //  }()
  let playViewController = PlayViewController()
 
  var searchResults: [Track] = []
  let queryService = QueryService()
  let downloadService = DownloadService()
  var isDownloadingInMain = false
  var noOfDownloadedTract = 0 {
    didSet {
      donwloadedLabel.text = "\(noOfDownloadedTract)"+"/150"
      if noOfDownloadedTract == 0 {
        allDownloadLabel.setTitle("전체설치시작", for: .normal)
        allDownloadLabel.isEnabled = true
      } else if noOfDownloadedTract == queryService.numberOfChapters  {
        allDownloadLabel.setTitle("전체설치완료", for: .disabled)
        allDownloadLabel.isEnabled = false
      } 
    }
    
  }
  // Create downloadsSession here, to set self as delegate
  lazy var downloadsSession: URLSession = {
    //  let configuration = URLSessionConfiguration.default
    let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  // Get local file path: download task stores tune here; AV player plays it.
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }
  
  
  @IBOutlet weak var donwloadedLabel: UILabel!
  @IBOutlet weak var allDownloadLabel: UIButton!
  
  
    @IBAction func deleteAllDownloaded(_ sender: Any) {
        deleteAll(results: searchResults)
    }
    @IBAction func allDownloadTapped(_ sender: UIButton) {
    
    switch sender.titleLabel?.text! {
      
    case "전체설치시작"? :
      
      let reachability = Reachability()!
      print (reachability.connection)
      
      if reachability.connection == .wifi {
        
        
        
        isDownloadingInMain = !isDownloadingInMain
        allDownloadLabel.setTitle("설치중단", for: .normal)
        
        for i in 0...queryService.numberOfChapters - 1{
          let indexPath = IndexPath(item: i, section: 0)
          let track = searchResults[indexPath.row]
          downloadService.startDownload(track)
          reload(indexPath.row)
          
        }
        
      } else {
        connectionAlert(title: "와이파이연결 이상", message: "와이파이연결이 약하거나 없습니다. 다시 연결후 시도하십시오")
        
      }
    case  "설치 재시작"? :
      
      let reachability = Reachability()!
      print (reachability.connection)
      
      if reachability.connection == .wifi {
        
        
        
        isDownloadingInMain = !isDownloadingInMain
        allDownloadLabel.setTitle("설치중단", for: .normal)
        
        for i in 0...queryService.numberOfChapters - 1{
          let indexPath = IndexPath(item: i, section: 0)
          let track = searchResults[indexPath.row]
          downloadService.startDownload(track)
          reload(indexPath.row)
          
        }
        
      } else {
        connectionAlert(title: "와이파이연결 이상", message: "와이파이연결이 약하거나 없습니다. 다시 연결후 시도하십시오")
        
      }
      
    case  "설치중단"?  :
      allDownloadLabel.setTitle("설치 재시작", for: .normal)
      for i in 0...queryService.numberOfChapters - 1{
        let indexPath = IndexPath(item: i, section: 0)
        let track = searchResults[indexPath.row]
        downloadService.cancelDownload(track)
        reload(indexPath.row)
      }
    default:
      
      print("default")
      
      
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchResults = queryService.getSearchResults()
    
    downloadService.downloadsSession = downloadsSession
    noOfDownloadedTract = checkDownloaded(results: searchResults)
    print (noOfDownloadedTract)
//    if noOfDownloadedTract == queryService.numberOfChapters {
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let newViewController = storyBoard.instantiateViewController(withIdentifier: "playViewController")
//    self.present(newViewController, animated: false, completion: nil)
//    }
    tableView.tableFooterView = UIView()
    tableView.reloadData()
    tableView.setContentOffset(CGPoint.zero, animated: false)
    
  }
  
  
//  func playDownload(_ track: Track) {
//    
//    let url = localFilePath(for: track.previewURL)
//    try! audioPlayer = AVAudioPlayer(contentsOf: url)
//    audioPlayer.prepareToPlay()
//    audioPlayer.play()
//  }
  
  
}
// MARK: - UITableView

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TrackCell = tableView.dequeueReusableCell(for: indexPath)
    
    // Delegate cell button tap events to this view controller
    cell.delegate = self
    
    let track = searchResults[indexPath.row]
    cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 62.0
  }
}
//  // When user taps cell, play the local file, if it's downloaded
////  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////    let track = searchResults[indexPath.row]
////    if track.downloaded {
////      playDownload(track)
////    }
//    tableView.deselectRow(at: indexPath, animated: true)
//  }
//}

// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.
extension SearchViewController: TrackCellDelegate {
  
  func downloadTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      //  searchResults.remove(at: indexPath.row)
      downloadService.startDownload(track)
      reload(indexPath.row)
      tableView.scrollToRow(at: indexPath, at: .top, animated: true)
      
      
    }
  }
  
  func cancelTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.cancelDownload(track)
      reload(indexPath.row)
    }
  }
  
  // Update track cell's buttons
  func reload(_ row: Int) {
    tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }
  
  func checkDownloaded(results: [Track])-> Int  {
    var j = 0
    for i in 0...queryService.numberOfChapters - 1{
      
      let fileName = results[i].artist
      let destinationFileUrl = documentsPath.appendingPathComponent(fileName)
      if  FileManager.default.fileExists(atPath: destinationFileUrl.path) {
        results[i].downloaded = true
     
        j += 1
      }
      
    }
    return j
  }
  
  func deleteAll(results: [Track]) {
    
    noOfDownloadedTract = 0
   
    for i in 0...queryService.numberOfChapters - 1{
      
      let fileName = results[i].artist
      let destinationFileUrl = documentsPath.appendingPathComponent(fileName)
      if  FileManager.default.fileExists(atPath: destinationFileUrl.path) {
         try?  FileManager.default.removeItem(at:  destinationFileUrl)
          results[i].downloaded = false
        
        
      }
      
    }
    
  }
  
  
  
  
  
  
  
  
}



