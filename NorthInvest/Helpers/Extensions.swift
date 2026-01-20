//
//  Extensions.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import Foundation
import SwiftUI

// MARK: - Number Formatting
extension Double {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    var formattedLeke: String {
        "\(formatted) L"
    }
}

// MARK: - Color Extensions
extension Color {
    static let appBackground = Color(red: 15/255, green: 23/255, blue: 42/255)
    static let cardBackground = Color(red: 30/255, green: 41/255, blue: 59/255)
    static let borderColor = Color(red: 51/255, green: 65/255, blue: 85/255)
    static let appGreen = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let appOrange = Color(red: 249/255, green: 115/255, blue: 22/255)
    static let appBlue = Color(red: 59/255, green: 130/255, blue: 246/255)
    static let appRed = Color(red: 239/255, green: 68/255, blue: 68/255)
    static let appYellow = Color(red: 234/255, green: 179/255, blue: 8/255)
    static let textSecondary = Color(red: 148/255, green: 163/255, blue: 184/255)
    static let textTertiary = Color(red: 100/255, green: 116/255, blue: 139/255)
}

// MARK: - Gradient Extensions
extension LinearGradient {
    static let greenGradient = LinearGradient(
        colors: [Color(red: 5/255, green: 150/255, blue: 105/255), Color(red: 4/255, green: 120/255, blue: 87/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let orangeGradient = LinearGradient(
        colors: [Color(red: 234/255, green: 88/255, blue: 12/255), Color(red: 194/255, green: 65/255, blue: 12/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [Color(red: 59/255, green: 130/255, blue: 246/255), Color(red: 37/255, green: 99/255, blue: 235/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let profitGradient = LinearGradient(
        colors: [Color(red: 22/255, green: 163/255, blue: 74/255), Color(red: 21/255, green: 128/255, blue: 61/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let lossGradient = LinearGradient(
        colors: [Color(red: 220/255, green: 38/255, blue: 38/255), Color(red: 185/255, green: 28/255, blue: 28/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(16)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
