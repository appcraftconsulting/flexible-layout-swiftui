//
//  ContentView.swift
//  FlexibleLayout
//
//  Created by François Boulais on 14/11/2022.
//

import SwiftUI

struct ContentView: View {
    struct Item: Identifiable {
        let id: Int
        let width: CGFloat
    }
    
    @State private var widthFactor: CGFloat = 1.0
    @State private var height: CGFloat = 20
    
    private let items: [Item] = (0...100).map { .init(id: $0, width: .random(in: 20...50)) }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                FlexibleLayout(horizontalSpacing: 6, verticalSpacing: 12) {
                    ForEach(items) { item in
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.teal)
                            .frame(width: item.width * widthFactor, height: height)
                    }
                }
                .animation(.default, value: widthFactor)
                .animation(.default, value: height)
                .padding()
            }
            
            Divider()
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text("width ")
                    Slider(value: $widthFactor, in: 1.0...3.0)
                }
                
                HStack(spacing: 12) {
                    Text("height")
                    Slider(value: $height, in: 20...50)
                }
            }
            .font(.callout.monospaced())
            .tint(.teal)
            .padding()
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}
