//
//  AppIconView.swift
//  NorthInvest
//
//  This view generates a preview of the app icon design.
//  Use this to screenshot and create your actual app icon.
//

import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 15/255, green: 23/255, blue: 42/255),
                    Color(red: 30/255, green: 41/255, blue: 59/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Icon content
            VStack(spacing: 0) {
                // Mountain/North symbol
                ZStack {
                    // Mountain shape
                    Triangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 16/255, green: 185/255, blue: 129/255),
                                    Color(red: 5/255, green: 150/255, blue: 105/255)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 500, height: 400)
                        .offset(y: 50)
                    
                    // Snow cap
                    Triangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 150, height: 120)
                        .offset(y: -90)
                    
                    // Arrow pointing up (growth)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 180, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 59/255, green: 130/255, blue: 246/255),
                                    Color(red: 37/255, green: 99/255, blue: 235/255)
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .offset(y: 30)
                }
                
                // Text
                Text("NI")
                    .font(.system(size: 200, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 16/255, green: 185/255, blue: 129/255),
                                Color(red: 59/255, green: 130/255, blue: 246/255)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(y: -20)
            }
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: 180))
    }
}

// Simple icon version
struct AppIconSimpleView: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 15/255, green: 23/255, blue: 42/255),
                    Color(red: 30/255, green: 41/255, blue: 59/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: -30) {
                // Chart bars going up
                HStack(alignment: .bottom, spacing: 40) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 16/255, green: 185/255, blue: 129/255))
                        .frame(width: 100, height: 250)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 59/255, green: 130/255, blue: 246/255))
                        .frame(width: 100, height: 400)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 16/255, green: 185/255, blue: 129/255))
                        .frame(width: 100, height: 550)
                }
                
                // NI Text
                HStack(spacing: 10) {
                    Text("N")
                        .foregroundColor(Color(red: 16/255, green: 185/255, blue: 129/255))
                    Text("I")
                        .foregroundColor(Color(red: 59/255, green: 130/255, blue: 246/255))
                }
                .font(.system(size: 280, weight: .black, design: .rounded))
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

// Minimal professional icon
struct AppIconMinimalView: View {
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 15/255, green: 23/255, blue: 42/255)
            
            // Circular accent
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 16/255, green: 185/255, blue: 129/255).opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 100,
                        endRadius: 500
                    )
                )
            
            // Main content
            VStack(spacing: 20) {
                // Up arrow with chart
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 16/255, green: 185/255, blue: 129/255),
                                    Color(red: 59/255, green: 130/255, blue: 246/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 30
                        )
                        .frame(width: 550, height: 550)
                    
                    // Arrow
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 280, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 16/255, green: 185/255, blue: 129/255),
                                    Color(red: 59/255, green: 130/255, blue: 246/255)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                // Text
                HStack(spacing: 0) {
                    Text("NORTH")
                        .foregroundColor(Color(red: 16/255, green: 185/255, blue: 129/255))
                    Text("INVEST")
                        .foregroundColor(Color(red: 59/255, green: 130/255, blue: 246/255))
                }
                .font(.system(size: 90, weight: .bold))
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

// Triangle shape for mountain
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview("Icon - Chart Style") {
    AppIconSimpleView()
        .frame(width: 300, height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 60))
}

#Preview("Icon - Minimal") {
    AppIconMinimalView()
        .frame(width: 300, height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 60))
}

#Preview("Icon - Mountain") {
    AppIconView()
        .frame(width: 300, height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 60))
}
