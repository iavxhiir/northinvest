//
//  FaturatView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct FaturatView: View {
    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedMuaj = ""
    @State private var showingForm = false
    @State private var editingItem: Fature?
    
    var filteredFaturat: [Fature] {
        store.data.faturat.filter { fature in
            let matchesSearch = searchText.isEmpty || 
                fature.klient.localizedCaseInsensitiveContains(searchText)
            let matchesMuaj = selectedMuaj.isEmpty || fature.muaj == selectedMuaj
            return matchesSearch && matchesMuaj
        }.reversed()
    }
    
    var totalSum: Double {
        filteredFaturat.reduce(0) { $0 + $1.total }
    }
    
    var paguarSum: Double {
        filteredFaturat.reduce(0) { $0 + $1.paguar }
    }
    
    var papaguarSum: Double {
        totalSum - paguarSum
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 12) {
                    // Filters
                    HStack(spacing: 10) {
                        TextField("Kerko klient...", text: $searchText)
                            .padding(14)
                            .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                        
                        Picker("Muaji", selection: $selectedMuaj) {
                            Text("Te gjitha").tag("")
                            ForEach(Constants.muajt, id: \.self) { muaj in
                                Text(muaj).tag(muaj)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 130)
                        .padding(10)
                        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    
                    // Summary Grid
                    HStack(spacing: 10) {
                        SummaryItem(label: "TOTALI", value: totalSum.formatted, color: .appGreen)
                        SummaryItem(label: "PAGUAR", value: paguarSum.formatted, color: .appBlue)
                        SummaryItem(label: "PAPAGUAR", value: papaguarSum.formatted, color: .appRed)
                    }
                    
                    // List
                    if filteredFaturat.isEmpty {
                        EmptyStateView(message: "Nuk ka fatura", submessage: "Shtyp + per te shtuar")
                    } else {
                        ForEach(Array(filteredFaturat), id: \.id) { fature in
                            FatureListItem(fature: fature) {
                                editingItem = fature
                                showingForm = true
                            } onDelete: {
                                store.deleteFature(fature)
                            } onUpdatePaguar: { newValue in
                                store.updatePaguar(faturaId: fature.id, paguar: newValue)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.appBackground)
            
            // FAB
            Button {
                editingItem = nil
                showingForm = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(LinearGradient.blueGradient)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .sheet(isPresented: $showingForm) {
            FatureFormView(existingItem: editingItem)
        }
    }
}

struct FatureListItem: View {
    let fature: Fature
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onUpdatePaguar: (Double) -> Void
    
    @State private var paguarText: String = ""
    
    var body: some View {
        ListItemCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(fature.klient.isEmpty ? "Pa klient" : fature.klient)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("\(fature.llogari) • \(fature.muaj.isEmpty ? "-" : fature.muaj)")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        ActionButton(title: "Ndrysho", color: .appBlue, action: onEdit)
                        ActionButton(title: "Fshij", color: .appRed, action: onDelete)
                    }
                }
                
                // Details Row
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Neto")
                            .font(.system(size: 11))
                            .foregroundColor(.textTertiary)
                        Text(fature.neto.formattedLeke)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TVSH")
                            .font(.system(size: 11))
                            .foregroundColor(.textTertiary)
                        Text(fature.tvsh.formattedLeke)
                            .font(.system(size: 13))
                            .foregroundColor(.appOrange)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total")
                            .font(.system(size: 11))
                            .foregroundColor(.textTertiary)
                        Text(fature.total.formattedLeke)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.appGreen)
                    }
                }
                
                Divider()
                    .background(Color.borderColor)
                
                // Paguar Row
                HStack {
                    Text("Paguar:")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    TextField("0", text: $paguarText)
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .onChange(of: paguarText) { _, newValue in
                            if let value = Double(newValue) {
                                onUpdatePaguar(value)
                            }
                        }
                    
                    Spacer()
                    
                    Text(fature.eshtePagear ? "✓ Paguar" : "Mbetje: \(fature.mbetje.formatted)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(fature.eshtePagear ? .appGreen : .appRed)
                }
            }
        }
        .onAppear {
            paguarText = fature.paguar > 0 ? String(format: "%.0f", fature.paguar) : ""
        }
    }
}

struct FatureFormView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    var existingItem: Fature?
    
    @State private var llogari = "2026"
    @State private var data = Date()
    @State private var muaj = ""
    @State private var klient = ""
    @State private var neto: Double = 0
    
    var tvsh: Double {
        neto * 0.2
    }
    
    var total: Double {
        neto * 1.2
    }
    
    var isEditing: Bool {
        existingItem != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    Picker("Viti i Llogarise", selection: $llogari) {
                        ForEach(Constants.vitet, id: \.self) { vit in
                            Text(vit).tag(vit)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    
                    DatePicker("Data", selection: $data, displayedComponents: .date)
                        .padding(14)
                        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    CustomPicker(title: "Muaji", selection: $muaj, options: Constants.muajt)
                    
                    CustomTextField(placeholder: "Klienti", text: $klient)
                    
                    CustomNumberField(placeholder: "Shuma Neto (pa TVSH)", value: $neto)
                    
                    // Preview Box
                    VStack(spacing: 8) {
                        HStack {
                            Text("TVSH 20%:")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Text(tvsh.formattedLeke)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.appOrange)
                        }
                        
                        HStack {
                            Text("TOTALI:")
                                .font(.system(size: 13))
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Text(total.formattedLeke)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.appGreen)
                        }
                    }
                    .padding(16)
                    .background(Color.appBlue.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.appBlue.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(14)
                    
                    SubmitButton(title: "RUAJ", gradient: .blueGradient) {
                        saveItem()
                    }
                }
                .padding(24)
            }
            .background(Color.cardBackground)
            .navigationTitle(isEditing ? "✏️ Ndrysho Faturë" : "+ Fature e Re")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mbyll") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
        .onAppear {
            if let item = existingItem {
                llogari = item.llogari
                data = item.data
                muaj = item.muaj
                klient = item.klient
                neto = item.neto
            }
        }
    }
    
    func saveItem() {
        var item = existingItem ?? Fature()
        item.llogari = llogari
        item.data = data
        item.muaj = muaj
        item.klient = klient
        item.neto = neto
        
        if isEditing {
            store.updateFature(item)
        } else {
            store.addFature(item)
        }
        
        dismiss()
    }
}

#Preview {
    FaturatView()
        .environmentObject(DataStore())
}
