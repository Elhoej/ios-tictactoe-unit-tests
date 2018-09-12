//
//  Game.swift
//  TicTacToe
//
//  Created by Simon Elhoej Steinmejer on 12/09/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

enum Opponent
{
    case ai
    case human
}

struct Game
{
    enum GameState
    {
        case active(GameBoard.Mark) // Active player
        case cat
        case won(GameBoard.Mark) // Winning player
    }
    
    private(set) var board: GameBoard
    internal var activePlayer: GameBoard.Mark?
    {
        didSet
        {
            if gameMode == .ai
            {
                if self.activePlayer == .o
                {
                    handleAITurn()
                }
            }
        }
    }
    internal var gameIsOver: Bool = false
    internal var winningPlayer: GameBoard.Mark?
    var gameMode: Opponent = .human
    
    var gameState = GameState.active(.x)

    init()
    {
        board = GameBoard()
        activePlayer = .x
        winningPlayer = nil
    }
    
    var availableMoves: [Coordinate] = [(x: 0, y: 0), (x: 0, y: 1), (x: 0, y: 2), (x: 1, y: 0), (x: 1, y: 1), (x: 1, y: 2), (x: 2, y: 0), (x: 2, y: 1), (x: 2, y: 2)]
    
    private mutating func handleAITurn()
    {
        var coord = (0, 0)
        
        coord = availableMoves[generateRandomNumber(min: 0, max: availableMoves.count - 1)]
        
        do {
            try makeMark(at: (coord.0, coord.1))
        } catch {
            NSLog("Invalid Mark")
        }
    }
    
    mutating internal func restart()
    {
        board = GameBoard()
        gameState = .active(.x)
        activePlayer = .x
        availableMoves = [(x: 0, y: 0), (x: 0, y: 1), (x: 0, y: 2), (x: 1, y: 0), (x: 1, y: 1), (x: 1, y: 2), (x: 2, y: 0), (x: 2, y: 1), (x: 2, y: 2)]
    }
    
    mutating internal func makeMark(at coordinate: Coordinate) throws
    {
        guard let player = activePlayer else { return }
        
        do
        {
            try board.place(mark: player, on: coordinate)
            removeMove(coord: coordinate)
            if game(board: board, isWonBy: player)
            {
                gameState = .won(player)
                gameIsOver = true
            } else if board.isFull
            {
                gameState = .cat
                gameIsOver = true
            } else
            {
                let newPlayer = player == .x ? GameBoard.Mark.o : GameBoard.Mark.x
                gameState = .active(newPlayer)
                activePlayer = newPlayer
            }
        } catch {
            NSLog("Illegal move")
        }
    }
    
    mutating func removeMove(coord: Coordinate)
    {
        for (index, move) in availableMoves.enumerated()
        {
            if move == coord
            {
                availableMoves.remove(at: index)
            }
        }
    }
    
    func generateRandomNumber(min: Int, max: Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
    }
}






