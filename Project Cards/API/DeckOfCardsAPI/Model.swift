//
//  Model.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 17/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//

import Foundation
struct DeckResponse: Codable {
    let success: Bool
    let deckID: String
    let shuffled: Bool
    let remaining: Int
    var error:String?
    
    enum CodingKeys: String, CodingKey {
        case success,error
        case deckID = "deck_id"
        case shuffled, remaining
    }
}

struct DrawResponse: Codable {
    let success: Bool
    let cards: [Card]
    let deckID: String
    let remaining: Int
    let error: String?
    
    
    enum CodingKeys: String, CodingKey {
        case success, cards, error
        case deckID = "deck_id"
        case remaining
    }
}

struct Card: Codable,CardRepresentable {
    var rank: CardRank {
        return value
    }
    
    var color: CardColor {
        return suit
    }
    
    var imageUrl: String {
        return image
    }
    
    let image: String
    let value:CardRank
    let suit:CardColor
    let code: String
}
