//
//  SingleplayerViewController.swift
//  TicTac
//
//  Created by Michal Sienkiewicz on 14.11.19.
//  Copyright © 2019 Michal Sienkiewicz. All rights reserved.
//

import UIKit

class SingleplayerViewController: UIViewController {

    @IBOutlet weak var difficultyLevel: UISegmentedControl!
    
    @IBOutlet weak var playerXScoreLabel: UILabel!
    @IBOutlet weak var playerOScoreLabel: UILabel!
    
    @IBOutlet weak var playerXImage: UIImageView!
    @IBOutlet weak var playerOImage: UIImageView!

    @IBOutlet var boardButtons: [UIButton]!
    
    var game: Game!
    var gameUIComponents: GameUIComponents!
    var animations: Animations!
        
    @IBAction func setPlayerSign(_ sender: UIButton) {
        game.setButtonSign(of: sender.tag, for: game.currentPlayer)
        game.nextMove(of: Player.X, to: sender.tag)
        setIphoneSign()
        
    }
    
    func setIphoneSign(){
        let iphonemove = calculateIphoneMove(in: game.board)
        if iphonemove != nil && game.currentPlayer == Player.O {
            game.setButtonSign(of: iphonemove!, for: game.currentPlayer)
            game.nextMove(of: Player.O, to: iphonemove!)
        }
        
    }
    
    
    func calculateIphoneMove(in board: [Player]) -> Int? {
        switch difficultyLevel.selectedSegmentIndex {
        case 0:
            return TicTacAI.calculateEasyIphoneMove(in: board)
        case 1:
            return TicTacAI.calculateMediumIphoneMove(in: board)
        default:
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    difficultyLevel.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        animations = Animations(viewController: self)
        
        gameUIComponents = GameUIComponents(
            boardButtons: boardButtons,
            playerXScoreLabel: playerXScoreLabel,
            playerOScoreLabel: playerOScoreLabel,
            playerXImage: playerXImage,
            playerOImage: playerOImage,
            animations: animations
        )
        
        game = Game(components: gameUIComponents)
        game.enableAI = true
        
        game.gameInit()
    }
}
