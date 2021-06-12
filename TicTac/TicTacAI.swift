//
//  TicTacAI.swift
//  TicTac
//
//  Created by Michal Sienkiewicz on 28.11.19.
//  Copyright © 2019 Michal Sienkiewicz. All rights reserved.
//

import Foundation

enum AIError: Error {
    case error(String)
}

struct TicTacAI {
    static func calculateEasyIphoneMove(in board: [Player]) -> Int? {
        let freeFieldIndexes:[Int] = Game.getBoardIndexes(of: Player.none, in: board)
        return freeFieldIndexes.randomElement()
    }
    
    static func calculateMediumIphoneMove(in board: [Player]) -> Int? {
        let freeIndexes = Game.getBoardIndexes(of: Player.none, in: board)
        let usedIndexes = Game.getBoardIndexes(of: Player.O, in: board)
        let xIndexes = Game.getBoardIndexes(of: Player.X, in: board)

        //Win
        for line in Game.winCombos {
            let missingWinIndexes = Set(line).subtracting(Set(usedIndexes))
            if missingWinIndexes.count == 1 && missingWinIndexes.isSubset(of: Set(freeIndexes)){
                return missingWinIndexes.first!
            }
        }
        
        //Blocking
        for line in Game.winCombos {
            let missingWinIndexesX = Set(line).subtracting(Set(xIndexes))
            if missingWinIndexesX.count == 1 && !missingWinIndexesX.isSubset(of: Set(usedIndexes)){
                return missingWinIndexesX.first!
            }
        }
        
        //Try to win
        for line in Game.winCombos {
            let usedIndexesInLine = Set(usedIndexes).intersection(Set(line))
            let xIndexesInLine = Set(xIndexes).intersection(Set(line))

            let isValidWinnigLine = usedIndexesInLine.isSubset(of: Set(line)) && xIndexesInLine.isEmpty
            if !isValidWinnigLine {
                continue
            }
            return Set(line).subtracting((Set(line).intersection(Set(usedIndexes)))).randomElement()!
            
        }
        return Set(freeIndexes).first
    }
}
