//
//  ContentView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: DataStore
    @State private var selectedTab = 0
    @State private var showingExport = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(showingExport: $showingExport)
            
            // Content
            TabView(selection: $selectedTab) {
                PanelView()
                    .tag(0)
                
                ArdhuraView()
                    .tag(1)
                
                ShpenzimetView()
                    .tag(2)
                
                FaturatView()
                    .tag(3)
                
                PagatView()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .background(Color.appBackground)
        .sheet(isPresented: $showingExport) {
            ExportView()
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    @EnvironmentObject var store: DataStore
    @Binding var showingExport: Bool
    
    var body: some View {
        HStack {
            // Save indicator
            VStack(alignment: .leading, spacing: 2) {
                if store.isSaving {
                    HStack(spacing: 4) {
                        ProgressView()
                            .scaleEffect(0.6)
                            .tint(.appGreen)
                        Text("Ruhet...")
                            .font(.system(size: 9))
                            .foregroundColor(.appGreen)
                    }
                } else if store.lastSaved != nil {
                    HStack(spacing: 3) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.appGreen)
                        Text("Ruajtur")
                            .font(.system(size: 9))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .frame(width: 60, alignment: .leading)
            .padding(.leading, 8)
            
            Spacer()
            
            VStack(spacing: 3) {
                HStack(spacing: 4) {
                    Text("NORTH")
                        .foregroundColor(.appGreen)
                    Text("INVEST")
                        .foregroundColor(.appBlue)
                    Text("SHPK")
                        .foregroundColor(.textTertiary)
                }
                .font(.system(size: 22, weight: .bold))
                
                Text("Programi Llogarites 2026 - Versioni i Ri ✅")
                    .font(.system(size: 11))
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            // Export Button
            Button {
                showingExport = true
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appBlue)
                    .padding(10)
                    .background(Color.appBlue.opacity(0.15))
                    .clipShape(Circle())
            }
            .padding(.trailing, 8)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                colors: [Color.cardBackground, Color.appBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.borderColor),
            alignment: .bottom
        )
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs: [(icon: String, title: String)] = [
        ("📊", "Panel"),
        ("💰", "Ardhura"),
        ("💸", "Shpenz."),
        ("📄", "Fatura"),
        ("👷", "Paga")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 3) {
                        Text(tabs[index].icon)
                            .font(.system(size: 22))
                        Text(tabs[index].title)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(selectedTab == index ? .white : .textTertiary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        selectedTab == index ? Color.borderColor : Color.clear
                    )
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background(Color.cardBackground)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.borderColor),
            alignment: .top
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
