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
// To parse the JSON, add this file to your project and do:
//
//   let drawResponse = try? newJSONDecoder().decode(DrawResponse.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDrawResponse { response in
//     if let drawResponse = response.result.value {
//       ...
//     }
//   }

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

enum CardColor:String,Codable {
    case HEARTS
    case DIAMONDS
    case CLUBS
    case SPADES
}

enum CardRank:String,Codable {
    case TWO
    case THREE
    case FOUR
    case FIVE
    case SIX
    case SEVEN
    case EIGHT
    case NINE
    case TEN
    case JACK
    case QUEEN
    case KING
    case ACE
    case JOKER
}


protocol CardRepresentable {
    var rank:CardRank { get }
    var color:CardColor { get }
    var code:String { get }
    var imageUrl:String { get }
}


protocol RepositoryRepresentable {
    func newDeckObservable()->Observable<DeckRepresentable>
}

public class DefaultRepository:RepositoryRepresentable {
    private let service = DeckOfCardsService()
    func newDeckObservable() -> Observable<DeckRepresentable> {
        return service.newDeckObservable()
            .map({ (response) -> DeckRepresentable in
            return response
        })
    }
}


protocol DeckRepresentable {
    func drawCardsObservable(cards:Int)->Observable<[Card]>
}


public class DeckOfCardsAPI {
    let basePath = "https://deckofcardsapi.com/api"
    let newShuffledDeckPath = "/deck/new/shuffle/?deck_count=1"
    
    func newDeckPath()->String {
        return "\(basePath)/deck/new/"
    }
    
    func drawPath(deckId:String,cards:Int)->String {
        return "\(basePath)/api/deck/\(deckId)/draw/?count=\(cards)"
    }
}


public class DeckOfCardsService {
    
    private let api = DeckOfCardsAPI()
    
    func newDeckObservable()->Observable<DeckResponse> {
        return BehaviorSubject<DeckResponse>.create { (observer) -> Disposable in
            Alamofire.request(self.api.newDeckPath()).responseDeckResponse { response in
                if let drawResponse = response.result.value {
                    observer.onNext(drawResponse)
                }
            }
            return Disposables.create()
        }
    }

    func drawObservable(deckId:String,cards:Int)->Observable<DrawResponse>{
        return BehaviorSubject<DrawResponse>.create { (observer) -> Disposable in
            Alamofire
                .request(self.api.drawPath(deckId: deckId, cards: cards))
                .responseDrawResponse { response in
                if let drawResponse = response.result.value {
                    observer.onNext(drawResponse)
                }
            }
            return Disposables.create()
        }
    }
}








struct DeckResponse: Codable,DeckRepresentable {
    
    func drawCardsObservable(cards:Int) -> Observable<[Card]> {
        return DeckOfCardsService()
            .drawObservable(deckId: self.deckID, cards: cards)
            .map { (response) -> [Card] in
            return response.cards
        }.asObservable()
    }
    
    let success: Bool
    let deckID: String
    let shuffled: Bool
    let remaining: Int
    
    enum CodingKeys: String, CodingKey {
        case success
        case deckID = "deck_id"
        case shuffled, remaining
    }
}

struct DrawResponse: Codable {
    let success: Bool
    let cards: [Card]
    let deckID: String
    let remaining: Int
    
    enum CodingKeys: String, CodingKey {
        case success, cards
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


fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDeckResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DeckResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseDrawResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DrawResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
