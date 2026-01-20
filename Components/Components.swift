//
//  Components.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

// MARK: - Stat Card
struct StatCard: View {
    let label: String
    let value: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .medium))
                .opacity(0.85)
            Text(value)
                .font(.system(size: 20, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(gradient)
        .cornerRadius(16)
        .foregroundColor(.white)
    }
}

// MARK: - Category Row
struct CategoryRow: View {
    let name: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                .font(.system(size: 14))
            Spacer()
            Text(value.formattedLeke)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Total Bar
struct TotalBar: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(color)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
        }
        .padding(14)
        .background(color.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// MARK: - Summary Item
struct SummaryItem: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - List Item Card
struct ListItemCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(14)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(14)
            .background(Color(red: 51/255, green: 65/255, blue: 85/255))
            .cornerRadius(12)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 71/255, green: 85/255, blue: 105/255), lineWidth: 1)
            )
    }
}

// MARK: - Custom Number Field
struct CustomNumberField: View {
    let placeholder: String
    @Binding var value: Double
    
    var body: some View {
        TextField(placeholder, value: $value, format: .number)
            .keyboardType(.decimalPad)
            .padding(14)
            .background(Color(red: 51/255, green: 65/255, blue: 85/255))
            .cornerRadius(12)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 71/255, green: 85/255, blue: 105/255), lineWidth: 1)
            )
    }
}

// MARK: - Custom Picker
struct CustomPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        Picker(title, selection: $selection) {
            Text("Zgjidh...").tag("")
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.menu)
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
        .cornerRadius(12)
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 71/255, green: 85/255, blue: 105/255), lineWidth: 1)
        )
    }
}

// MARK: - Preview Box
struct PreviewBox: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(color.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// MARK: - Submit Button
struct SubmitButton: View {
    let title: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(gradient)
                .cornerRadius(14)
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let message: String
    let submessage: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.textTertiary)
            Text(submessage)
                .font(.system(size: 13))
                .foregroundColor(.textTertiary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(50)
    }
}
