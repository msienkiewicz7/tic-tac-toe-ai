//
//  GameLogic.swift
//  TicTac
//
//  Created by Michal Sienkiewicz on 23.11.19.
//  Copyright © 2019 Michal Sienkiewicz. All rights reserved.
//

import Foundation
import UIKit

struct Animations {
    var viewController: UIViewController

    func increasingAnimation(constraints: [NSLayoutConstraint]){
        for c in constraints {
            c.constant += 30
        }
        viewController.view.layoutIfNeeded()
    }
    
    func decreasingAnimation(constraints: [NSLayoutConstraint]){
        for c in constraints {
            c.constant -= 30
        }
        viewController.view.layoutIfNeeded()
    }
}

struct GameUIComponents {
    
    var boardButtons: [UIButton]
    var playerXScoreLabel: UILabel
    var playerOScoreLabel: UILabel
    var playerXImage: UIImageView
    var playerOImage: UIImageView
    var animations: Animations
    
    func getButtons(_ indexes: Set<Int>) -> [UIButton]{
        var btns = [UIButton]()
        for i in indexes {
            btns.append(boardButtons[i])
        }
        return btns
    }
    
    func changeButtonsBackground(indexes: Set<Int>, color: UIColor){
        for button in getButtons(indexes) {
            button.backgroundColor = color
        }
    }
    
    func changeButtonsSignColor(indexes: Set<Int>, color: UIColor){
        for button in getButtons(indexes) {
            button.tintColor = color
        }
    }
    
    func clearBoard() {
        for button in boardButtons {
            button.setImage(nil, for: UIControl.State.normal)
        }
    }
    
    func hideNextTurnSigns(){
        playerXImage.tintColor = UIColor.black
        playerOImage.tintColor = UIColor.black
    }
    
    func setNextTurnSignColor(for nextPlayer: Player) {
        playerXImage.tintColor = nextPlayer == Player.X ? UIColor.systemRed : UIColor.black
           playerOImage.tintColor = !(nextPlayer == Player.X) ? UIColor.systemBlue : UIColor.black
    }
    
    func increaseScore(of winner: Player){
        if winner == Player.X {
             playerXScoreLabel.text = String(Int(playerXScoreLabel.text!)! + 1)
         } else {
             playerOScoreLabel.text = String(Int(playerOScoreLabel.text!)! + 1)
         }
    }
    
    func animateWinnerSign(xIsNext: Bool) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
             UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.animations.increasingAnimation(constraints: xIsNext ? self.playerXImage.constraints : self.playerOImage.constraints)
             })
             UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.5, animations: {
                self.animations.decreasingAnimation(constraints: xIsNext ? self.playerXImage.constraints : self.playerOImage.constraints)
             })
         })
    }
    
    func setButtonSign(of index: Int, for player: Player){
        boardButtons[index].tintColor = player == Player.X ? UIColor.systemRed : UIColor.systemBlue
        boardButtons[index].setImage(player == Player.X ? xSign : oSign, for: UIControl.State.normal)
    }
}

enum Player {
    case X, O, none
}

struct Game {
    static let winCombos = Set([ Set([0, 1, 2]), [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6] ])
    
    var components: GameUIComponents
    var hasGameEnded: Bool {
        return winner != Player.none || isDraw
    }
    var enableAI: Bool = false
    
    var currentPlayer: Player = Player.X
    var winner = Player.none
    var winCombo: Set<Int>?
    
    var board = [Player](repeating: Player.none, count: 9)

    
    var isDraw: Bool {
        return board.firstIndex(of: Player.none) == nil && winner == Player.none
    }
    
    static func getBoardIndexes(of player: Player, in board: [Player]) -> [Int] {
        var boardIndexes:[Int] = [Int]()
        for (i, field) in board.enumerated() {
            if field == player {
                boardIndexes.append(i);
            }
        }
        return boardIndexes
    }
    
    func setButtonSign(of index: Int, for player: Player){
        if (board[index] == Player.none && !hasGameEnded) {
            components.setButtonSign(of: index, for: player)
        }
    }
    
    mutating func nextMove(of player: Player, to index: Int){
        if (board[index] == Player.none && !hasGameEnded) {
            print(player, index)
            currentPlayer = player
            board[index] = player
                        
            if (calculateWinner() == Player.none && !isDraw) {
                nextRound()
            } else {
                nextGame()
            }

        }
        else if hasGameEnded {
            if !(enableAI && player == Player.O) {
               gameInit()
            }

            
            if enableAI && winner == Player.O {
                nextMove(of: Player.O, to: index)
            }
        }
    }
    
    private mutating func nextRound(){
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X
        components.setNextTurnSignColor(for : currentPlayer)
    }
    

    
    private mutating func nextGame(){
        if !isDraw {
//            components.animateWinnerSign(xIsNext: xIsNext)
            components.increaseScore(of: currentPlayer)
            components.changeButtonsBackground(indexes: winCombo!, color: currentPlayer == Player.X ? UIColor.systemRed : UIColor.systemBlue)
            components.changeButtonsSignColor(indexes: winCombo!, color: boardColor)
            currentPlayer = winner == Player.X ? Player.O : Player.X
        }
        components.hideNextTurnSigns()
    }
    
    mutating func calculateWinner() -> Player {
        let p_moves = Game.getBoardIndexes(of: currentPlayer, in: board)
        for winCombo in Game.winCombos {
            if winCombo.isSubset(of: Set(p_moves)) {
                self.winCombo = winCombo
                winner = currentPlayer
                return currentPlayer
            }
        }
        return Player.none
    }
    
    mutating func gameInit(){
        components.clearBoard()
        components.changeButtonsBackground(indexes: Set(Array(0...8)), color: boardColor)
        components.setNextTurnSignColor(for: currentPlayer)
        winner = Player.none
        board = [Player](repeating: Player.none, count: 9)
    }
}
