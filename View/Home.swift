//
//  Home.swift
//  ScrollViewOffsetContent
//
//  Created by Maxim Macari on 4/4/21.
//

import SwiftUI

struct Home: View {
    
    @State var offset: CGPoint = CGPoint.zero
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                CustomScrollView(offset: $offset, showIndicators: false, axis: .vertical){
                    //change between VStack and HStack, change also the axis
                    LazyVStack(spacing: 15){
                        ForEach(1...30, id: \.self){ _ in
                            HStack(spacing: 15, content: {
                                Circle()
                                    .fill(Color.gray.opacity(0.7))
                                    .frame(width: 70, height: 70)
                                
                                VStack(alignment: .leading, spacing: 15, content: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.6))
                                        .frame(height: 15)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.6))
                                        .frame(height: 15)
                                        .padding(.trailing, 90)
                                })
                            })
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("Offset: \(String(format: "%.1f", offset.y))")
            })
        }
    }
}

//ViewBUilder
struct CustomScrollView<Content: View>: View {

    //to hold our view
    //to capture the decribeed view
    var content: Content
    
    @Binding var offset: CGPoint
    var showIndicators: Bool
    var axis: Axis.Set

    //sincee it will  carry multiple views
    //so it will ve a closure and it will return view
    init(offset: Binding<CGPoint>, showIndicators: Bool, axis: Axis.Set, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
        self.showIndicators = showIndicators
        self.axis = axis
    }
    
    @State var startOffset: CGPoint = CGPoint.zero
    
    var body: some View{
        ScrollView(axis, showsIndicators: showIndicators, content: {
            content
            
            //getting offset
                .overlay(
                    GeometryReader { geo -> Color in
                        let rect = geo.frame(in: .global)
                        if startOffset == .zero {
                            DispatchQueue.main.async {
                                startOffset = CGPoint(x: rect.minX, y: rect.minY)
                            }
                        }
                        DispatchQueue.main.async {
                            //  minus from the current
                            self.offset = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
                        }
                        return Color.clear
                    }
                    //Since we're also fetching horizontal offset
                    //so setting to full so that minX will be zero
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    , alignment: .top
                )
        })
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
