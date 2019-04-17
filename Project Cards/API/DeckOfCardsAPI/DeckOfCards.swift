//
//  DeckOfCardsAPI.swift
//  Project Cards
//
//  Created by Ernest Chechelski on 16/04/2019.
//  Copyright © 2019 Ernest Chechelski. All rights reserved.
//


import Foundation
import Alamofire
import RxSwift
import RxDataSources

struct SectionViewModel {
    var header:String
    var items:[Item]
}

extension SectionViewModel :AnimatableSectionModelType {
    typealias Item = String
    var identity:String {
        return header
    }
    
    init(original:SectionViewModel,items:[Item]) {
        self = original
        self.items = items
    }
}

extension CardRank :Codable {
    enum CodingKeys: String, CodingKey {
        case TWO = "2"
        case THREE = "3"
        case FOUR = "4"
        case FIVE = "5"
        case SIX = "6"
        case SEVEN = "7"
        case EIGHT = "8"
        case NINE = "9"
        case TEN = "10"
        case JACK = "JACK"
        case QUEEN = "QUEEN"
        case KING = "KING"
        case ACE = "ACE"
        case JOKER = "JOKER"
    }
}

extension CardColor : Codable {
    enum CodingKeys: String, CodingKey {
        case HEARTS
        case DIAMONDS
        case CLUBS
        case SPADES
    }
}


extension DeckResponse : DeckRepresentable {
   
    func drawCardsObservable(cards:Int) -> Observable<[CardRepresentable]> {
        return DeckOfCardsService()
            .drawObservable(deckId: self.deckID, cards: cards)
            .map { (response) -> [CardRepresentable] in
                var result = [CardRepresentable]()
                result.append(contentsOf: response.cards)
                return result
            }.asObservable()
    }
}


extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else {
                print("Error: \(error)")
                return .failure(error!)
            }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            return Result { try self.newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        var result = response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
        
        return result
    }
    
    @discardableResult
    func responseDeckResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DeckResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDrawResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DrawResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
}
