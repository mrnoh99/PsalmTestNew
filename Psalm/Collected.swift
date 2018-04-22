//
//  Collected.swift
//  Psalm
//
//  Created by NohJaisung on 2018. 4. 7..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import Foundation
struct Collected  {
  let collName: String
  let collArray: [Int]
//  init(collName: String, collArray: [Int])
//  {
//    self.collName = collName
//    self.collArray  = collArray
//    
//  }
}

class CollectedService {
  
 
  
  var kindDic :[String:[Int]] = [
    "A. 전체시편" : [],
    "B. 참회 시편":[5,31,37,50,101,129,142],
    "C. 미세레레 Miserere 데 프로픈디스 De Profundis" : [50,129],
    "D. 개인 탄원 시편" :[4,5,6,12,16,21,24,25,27,30,34,35,37,38,41,42,50,53,54,55,56,58,60,62,63,68,69,39,13,14,15,16,17,70,85,87,101,108,119,129,139,140,141,142],
    "E. 공동 탄원 시편" : [11,43,57,59,73,78,79,82,84,89,122,125],
    "F. 개인 감사 시편" : [29,31,33,39,1,2,3,4,5,6,7,8,9,10,11,91,115,117,137],
    "G. 공동 감사 시편" : [65, 7,8,9,10,11,126,127,132],
    "H. 교훈 시편" : [0,36,48,111,118,126,132,72,127,138],
    "I. 시온의 노래" : [45,47,75,83,86,23,67,131],
    "J. 군왕 시편" : [1,17,19,20,44,71,88,100,109,131,143],
    "K. 기도서" : [14,19,23,13,52,65,80,81,84,94,106,114,117,120,125,131,133]
    ]
  
  
  func getCollected()-> [Collected] {

  var kind: [Collected] = []
    let kindDicsorted = kindDic.sorted(by: { $0.key < $1.key})
    

    for (collName,collArray)  in kindDicsorted {
      kind.append(Collected(collName: collName, collArray: collArray))
  }
  return kind
}
}
  
  
  
  

  

