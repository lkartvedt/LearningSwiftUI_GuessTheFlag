//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lindsey Kartvedt on 7/18/23.
//

import SwiftUI


struct FlagImage: View {
    var flagNumber: String

    var body: some View {
        Image(flagNumber)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}

struct ContentView: View {
    
    @State private var isFlagClicked = false
    @State private var scoreTitle = ""
    @State private var endGameTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var isGameFinished = false
    @State private var currentRound = 1
    
    let rounds = 8
    let desaturatedBlue = Color(red: 0.1, green: 0.2, blue: 0.45)
    let desaturatedRed = Color(red: 0.76, green: 0.15, blue: 0.26)
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(stops: [
                    .init(color: desaturatedBlue, location: 0.33),
                    .init(color: desaturatedRed, location: 0.66),
                ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                
                Text("Guess the Flag")
                    .modifier(Title())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary).font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary).font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flagNumber: countries[number])

                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Round: \(currentRound)/\(rounds)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $isFlagClicked) {
            Button("Continue", action: askQuestion)
        }
        .alert(endGameTitle, isPresented: $isGameFinished) {
            Button("New Game", action: restartGame)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Whoops, that is the flag of " + countries[number] + "."
        }
        if(currentRound == rounds){
            isGameFinished = true
            endGameTitle = "Congrats! You finished the game with a final score of \(score)!"
        }else{
            isFlagClicked = true
        }
        
        
        
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in:0...2)
        currentRound += 1
    }
    
    func restartGame(){
        countries.shuffle()
        correctAnswer = Int.random(in:0...2)
        currentRound = 0
        score = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
