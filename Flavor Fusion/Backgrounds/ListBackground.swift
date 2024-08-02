//
//  ListBackground.swift
//  Flavor Fusion
//
//  Created by Allison Turner on 3/31/24.
//

import SwiftUI

struct ListBackground: View {
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.pink, .cyan.opacity(0.5)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .clipShape(CurvedShape())
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height), control: CGPoint(x: rect.midX, y: rect.height * 0.8))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ListBackground()
}
