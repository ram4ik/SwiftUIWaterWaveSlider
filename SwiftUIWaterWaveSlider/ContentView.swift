//
//  ContentView.swift
//  SwiftUIWaterWaveSlider
//
//  Created by Ramill Ibragimov on 08.08.2020.
//

import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0.3
    @State var phrase: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            WaterWave(progress: self.progress, phrase: self.phrase)
                .fill(Color.blue)
                .clipShape(Capsule())
                .shadow(radius: 10)
                .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ (value) in
                                self.progress = (1 - (value.location.y / geometry.size.height)) - 0.2
                            }))
        }.onAppear() {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phrase = .pi * 2
            }
        }
        
    }
}

struct WaterWave: Shape {
    
    let progress: CGFloat
    var applitude: CGFloat = 10
    var waveLength: CGFloat = 20
    var phrase: CGFloat
    
    var animatableData: CGFloat {
        get { phrase }
        set { phrase = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midWidth = width / 2
        let progressHeight = height * (1 - progress)
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        for x in stride(from: 0, to: width + 5, by: 5) {
            let relativeX = x / waveLength
            let normalizedLength = (x - midWidth) / midWidth
            let y = progressHeight + sin(phrase + relativeX) * applitude * normalizedLength
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
