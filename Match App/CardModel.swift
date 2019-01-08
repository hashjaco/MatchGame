//
//  CardModel.swift
//  Match App
//
//  Created by Hashim Jacobs on 12/30/18.
//  Copyright © 2018 Syntheticherorism. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card]{
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Declare array
        var generatedNumbersArray = [UInt32]()
        
        // Randomly generate pairs of cards
        for _ in 1...8 {
            
            var randomNumber:UInt32?
            
            repeat {
                randomNumber = arc4random_uniform(13) + 1
            } while (generatedNumbersArray.contains(randomNumber!))
            
            
            let cardImage = "card\(randomNumber!)"
            
            print(randomNumber!)
        
            // Create first card object
            let cardOne = Card()
            cardOne.imageName = cardImage
        
        
            generatedCardsArray.append(cardOne)
        
            // Create second card object
            let cardTwo = Card()
            cardTwo.imageName = cardImage
        
            generatedCardsArray.append(cardTwo)
            generatedNumbersArray.append(randomNumber!)
            // OPTIONAL: Make it so we only have unique pairs of cards
        }
        // Randomize the array
        generatedCardsArray.shuffle()
        // Return the array
        return generatedCardsArray
        
    }

}
