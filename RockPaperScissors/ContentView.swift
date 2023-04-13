//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Uriel Ortega on 11/04/23.
//

import SwiftUI

struct Dock: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.20), radius: 25)
            .padding()
    }
}

extension View {
    func dockStyle() -> some View {
        modifier(Dock())
    }
}

struct ContentView: View {
    let movesWithEmoji: [(name: String, emoji: String)] = [
        ("Rock", "🪨"),
        ("Paper", "📄"),
        ("Scissors", "✂️")
    ]
    
    let solutions: [(losingMove: String, winningMove: String)] = [
        ("Rock", "Paper"),
        ("Paper", "Scissors"),
        ("Scissors", "Rock")
    ]
    
    @State private var shouldWin = Bool.random()
    @State private var opponentMoveIndex = Int.random(in: 0...2)
    @State private var selectedMoveIndex = 0
    
    @State private var numberOfQuestion = 1
    @State private var score = 0
    @State private var win = false
    
    @State private var showingFinalMessage = false
    
    private var answer: (opponentMove: String, selectedMove: String) { // Computed property
        (movesWithEmoji[opponentMoveIndex].name, movesWithEmoji[selectedMoveIndex].name)
    }
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.clear, Color(red: 0.9, green: 0, blue: 2.0)]), center: .center, startRadius: 10, endRadius: 1000)
                .ignoresSafeArea()
            
            VStack {
                Text("Question \(numberOfQuestion)/10")
                    .font(.subheadline)
                    .padding(.bottom)
                    .animation(.default, value: numberOfQuestion)
                
                Text("Score: \(score)")
                    .font(.headline)
                    .animation(.default, value: score)
                                
                Spacer()

                Text(shouldWin ? "Win against..." : "Lose against...")
                    .font(.largeTitle.bold())
                Text(movesWithEmoji[opponentMoveIndex].emoji)
                    .font(.system(size: 200))
                
                Spacer()
                
                HStack {
                    ForEach(movesWithEmoji.indices, id: \.self) { moveIndex in
                        Button {
                            answerTapped(moveIndex)
                        } label: {
                            Text(movesWithEmoji[moveIndex].emoji)
                                .font(.system(size: 70))
                                .padding()
                        }
                    }
                }
                .dockStyle()
            }
            .padding()
        }
        .alert("Game over!", isPresented: $showingFinalMessage) {
            Button("Let's go!", action: reset)
        } message: {
            Text("Wanna try again?")
        }
    }
    
    func answerTapped(_ moveIndex: Int) {
        selectedMoveIndex = moveIndex
        
        if shouldWin {
            win = solutions.contains { $0 == answer } // The answer must be a tuple declared in the solutions array
        } else {
            win = !(solutions.contains { $0 == answer }) // The answer must NOT be a tuple declared in the solutions array
        }
        
        if win {
            score += 1
        } else {
            score -= 1
        }
        
        if numberOfQuestion < 10 {
            createQuestion()
        } else {
            showingFinalMessage = true
        }
    }
    
    func createQuestion() {
        shouldWin.toggle()
        opponentMoveIndex = Int.random(in: 0...2)
        numberOfQuestion += 1
    }
    
    func reset() {
        score = 0
        numberOfQuestion = 0
        
        createQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
