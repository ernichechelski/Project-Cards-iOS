//
//  DeckOfCardsApi.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
import Alamofire
public class DeckOfCardsAPI {
    let basePath = "https://deckofcardsapi.com/api"
  
    func newDeckRequest() -> DataRequest {
        return Alamofire.request(self.newDeckPath())
    }
    
    func drawCardRequest(deckId:String,cards:Int) -> DataRequest{
         return Alamofire.request(self.drawPath(deckId: deckId, cards: cards))
    }
    
    private func newDeckPath()->String {
        return "\(basePath)/deck/new/"
    }
    
    private func drawPath(deckId:String,cards:Int)->String {
        return "\(basePath)/deck/\(deckId)/draw/?count=\(cards)"
    }
}
