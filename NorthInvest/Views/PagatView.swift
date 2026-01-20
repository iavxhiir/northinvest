//
//  PagatView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct PagatView: View {
    @EnvironmentObject var store: DataStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Total Bar
                TotalBar(label: "PAGA VJETORE:", value: store.totalPaga.formattedLeke, color: .appYellow)
                
                // Employee Cards
                ForEach(store.data.punonjesit) { punonjes in
                    PunonjesCard(punonjes: punonjes)
                }
            }
            .padding(16)
        }
        .background(Color.appBackground)
    }
}

struct PunonjesCard: View {
    @EnvironmentObject var store: DataStore
    let punonjes: Punonjes
    
    @State private var emri: String = ""
    @State private var pozicioni: String = ""
    @State private var pagat: [String] = Array(repeating: "", count: 12)
    
    var totalPaga: Double {
        pagat.compactMap { Double($0) }.reduce(0, +)
    }
    
    var body: some View {
        VStack(spacing: 14) {
            // Header
            HStack(spacing: 10) {
                TextField("Emri", text: $emri)
                    .padding(10)
                    .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onChange(of: emri) { _, newValue in
                        var updated = punonjes
                        updated.emri = newValue
                        store.updatePunonjes(updated)
                    }
                
                Picker("Pozicioni", selection: $pozicioni) {
                    ForEach(Constants.pozicionet, id: \.self) { poz in
                        Text(poz).tag(poz)
                    }
                }
                .pickerStyle(.menu)
                .padding(8)
                .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                .cornerRadius(8)
                .foregroundColor(.white)
                .onChange(of: pozicioni) { _, newValue in
                    var updated = punonjes
                    updated.pozicioni = newValue
                    store.updatePunonjes(updated)
                }
            }
            
            // Monthly Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(0..<12, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(String(Constants.muajt[index].prefix(3)))
                            .font(.system(size: 11))
                            .foregroundColor(.textTertiary)
                        
                        TextField("0", text: $pagat[index])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                            .onChange(of: pagat[index]) { _, newValue in
                                let value = Double(newValue) ?? 0
                                store.updatePaga(punonjesId: punonjes.id, muajIndex: index, vlera: value)
                            }
                    }
                }
            }
            
            // Total
            HStack {
                Spacer()
                Text("Totali: \(totalPaga.formattedLeke)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appYellow)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .cornerRadius(16)
        .onAppear {
            emri = punonjes.emri
            pozicioni = punonjes.pozicioni
            pagat = punonjes.pagaMujore.map { $0 > 0 ? String(format: "%.0f", $0) : "" }
        }
    }
}

#Preview {
    PagatView()
        .environmentObject(DataStore())
}
