

import Foundation.NSURL

// Query service creates Track objects
class Track {

  let name: String
  let artist: String
  let previewURL: URL
  let index: Int
  var downloaded = false
  let firstLine: String

  init(name: String, artist: String, previewURL: URL, index: Int, firstLine: String) {
    self.name = name
    self.artist = artist
    self.firstLine = firstLine
    self.previewURL = previewURL
    self.index = index
  }
  
}
