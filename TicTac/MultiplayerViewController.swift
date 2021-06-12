//
//  ViewController.swift
//  TicTac
//
//  Created by Michal Sienkiewicz on 01.11.19.
//  Copyright © 2019 Michal Sienkiewicz. All rights reserved.
//

import UIKit

class MultiplayerViewController: UIViewController {
    // UIComponents
    @IBOutlet weak var playerXScoreLabel: UILabel!
    @IBOutlet weak var playerOScoreLabel: UILabel!
    
    @IBOutlet weak var playerXImage: UIImageView!
    @IBOutlet weak var playerOImage: UIImageView!

    @IBOutlet var boardButtons: [UIButton]!
    
    var game: Game!
    var gameUIComponents: GameUIComponents!
    var animations: Animations!

    @IBAction func setSign(_ sender: UIButton) {
        game.setButtonSign(of: sender.tag, for: game.currentPlayer)
        game.nextMove(of: game.currentPlayer, to: sender.tag)
        
    }
    
    @IBAction func resetBoard(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        game.gameInit()
    }
    

}

