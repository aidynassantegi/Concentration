//
//  Concentration.swift
//  Concentration
//
//  Created by Aidyn Assan on 12.05.2022.
//

import Foundation

var gameCount = 0 {
    didSet {
        
    }
}

protocol ConcentrationDelegate: AnyObject {
    func didUpdate(with count: Int)
}

class Concentration {
    private(set) var cards: [Card] = []
    
    weak var delegate: ConcentrationDelegate?
    private var flipCount = 0 {
        didSet {
            delegate?.didUpdate(with: flipCount)
        }
    }
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardsIndices = cards.indices.filter {cards[$0].isFaceUp}
            return faceUpCardsIndices.count == 1 ? faceUpCardsIndices.first : nil
        }set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = cards.shuffled()
    }
    
    func chooseCard(at index: Int) {
        guard !cards[index].isMatched else { return }
        flipCount += 1
        if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
            if cards[matchIndex] == cards[index] {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
        }else {
            indexOfOneAndOnlyFaceUpCard = index
        }
    }
    
    deinit {
        gameCount += 1
        print("Game number \(gameCount) ended!")
    }
}
