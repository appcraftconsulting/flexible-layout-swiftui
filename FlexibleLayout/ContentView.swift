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
    @State private var selectedId: Int? = nil
    
    private let items: [Item] = (0...1000).map { .init(id: $0, width: .random(in: 20...50)) }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    FlexibleLayout(horizontalSpacing: 6, verticalSpacing: 12) {
                        ForEach(items) { item in
                            Button {
                                selectedId = item.id
                            } label: {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.id == selectedId ? .green : .teal)
                                    .frame(width: item.width * widthFactor, height: height)
                            }
                            .id(item.id)
                        }
                    }
                    .onChange(of: selectedId) { id in
                        withAnimation {
                            proxy.scrollTo(selectedId, anchor: .center)
                        }
                    }
                    .animation(.spring(), value: widthFactor)
                    .animation(.spring(), value: height)
                    .animation(.spring(), value: selectedId)
                    .padding()
                }
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
