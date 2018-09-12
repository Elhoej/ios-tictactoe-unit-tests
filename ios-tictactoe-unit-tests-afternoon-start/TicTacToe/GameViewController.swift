//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Andrew R Madsen on 9/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, BoardViewControllerDelegate
{
    var game = Game()
    {
        didSet
        {
            boardViewController.board = game.board
            updateViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        chooseGameMode()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        chooseGameMode()
    }
    
    private func chooseGameMode()
    {
        let alert = UIAlertController(title: "Choose your opponent", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "AI", style: .destructive, handler: { (_) in
            
            self.game.gameMode = .ai
        }))
        alert.addAction(UIAlertAction(title: "Human", style: .default, handler: { (_) in
            
            self.game.gameMode = .human
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func restartGame(_ sender: Any)
    {
        unlockGameBoard()
        game.restart()
    }
    
    // MARK: - BoardViewControllerDelegate
    
    func boardViewController(markWasMadeAt coordinate: Coordinate)
    {
        do {
            try game.makeMark(at: coordinate)
        } catch {
            NSLog("Invalid Mark")
        }
    }
    
    // MARK: - Private
    
    private func updateViews()
    {
        guard isViewLoaded else { return }
        let gameState = game.gameState
        switch gameState
        {
        case let .active(player):
            statusLabel.text = "Player \(player.stringValue)'s turn"
        case .cat:
            statusLabel.text = "Cat's game!"
            lockGameBoard()
            showAlert(withText: "Cat's game, it's a draw!")
        case let .won(player):
            statusLabel.text = "Player \(player.stringValue) won!"
            lockGameBoard()
            showAlert(withText: "Congratulations player \(player.stringValue), you won!")
        }
    }
    
    func lockGameBoard()
    {
        for button in boardViewController.buttons
        {
            button.isEnabled = false
        }
    }
    
    func unlockGameBoard()
    {
        for button in boardViewController.buttons
        {
            button.isEnabled = true
        }
    }
    
    private func showAlert(withText text: String)
    {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedBoard"
        {
            boardViewController = segue.destination as! BoardViewController
        }
    }
    
    private var boardViewController: BoardViewController!
    {
        willSet
        {
            boardViewController?.delegate = nil
        }
        didSet
        {
            boardViewController?.board = game.board
            boardViewController?.delegate = self
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    
}
