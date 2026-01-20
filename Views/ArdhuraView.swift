//
//  ArdhuraView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct ArdhuraView: View {
    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedMuaj = ""
    @State private var showingForm = false
    @State private var editingItem: Ardhure?
    
    var filteredArdhurat: [Ardhure] {
        store.data.ardhurat.filter { ardhure in
            let matchesSearch = searchText.isEmpty || 
                ardhure.klient.localizedCaseInsensitiveContains(searchText)
            let matchesMuaj = selectedMuaj.isEmpty || ardhure.muaj == selectedMuaj
            return matchesSearch && matchesMuaj
        }.reversed()
    }
    
    var filteredTotal: Double {
        filteredArdhurat.reduce(0) { $0 + $1.shuma }
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
                    
                    // Total Bar
                    TotalBar(label: "TOTALI:", value: filteredTotal.formattedLeke, color: .appGreen)
                    
                    // List
                    if filteredArdhurat.isEmpty {
                        EmptyStateView(message: "Nuk ka te dhena", submessage: "Shtyp + per te shtuar")
                    } else {
                        ForEach(Array(filteredArdhurat), id: \.id) { ardhure in
                            ArdhuraListItem(ardhure: ardhure) {
                                editingItem = ardhure
                                showingForm = true
                            } onDelete: {
                                store.deleteArdhure(ardhure)
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
                    .background(LinearGradient.greenGradient)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .sheet(isPresented: $showingForm) {
            ArdhuraFormView(existingItem: editingItem)
        }
    }
}

struct ArdhuraListItem: View {
    let ardhure: Ardhure
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        ListItemCard {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(ardhure.klient.isEmpty ? "Pa klient" : ardhure.klient)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(ardhure.sherbim.isEmpty ? "-" : ardhure.sherbim) • \(ardhure.muaj.isEmpty ? "-" : ardhure.muaj)")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    Text("\(Int(ardhure.sasi)) \(ardhure.njesi) × \(ardhure.cmim.formatted) L")
                        .font(.system(size: 12))
                        .foregroundColor(.textTertiary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(ardhure.shuma.formattedLeke)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appGreen)
                    
                    HStack(spacing: 6) {
                        ActionButton(title: "Ndrysho", color: .appBlue, action: onEdit)
                        ActionButton(title: "Fshij", color: .appRed, action: onDelete)
                    }
                }
            }
        }
    }
}

struct ArdhuraFormView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    var existingItem: Ardhure?
    
    @State private var data = Date()
    @State private var muaj = ""
    @State private var sherbim = ""
    @State private var klient = ""
    @State private var pershkrim = ""
    @State private var sasi: Double = 0
    @State private var cmim: Double = 0
    @State private var njesi = "TON"
    
    var shuma: Double {
        sasi * cmim
    }
    
    var isEditing: Bool {
        existingItem != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    DatePicker("Data", selection: $data, displayedComponents: .date)
                        .padding(14)
                        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    CustomPicker(title: "Muaji", selection: $muaj, options: Constants.muajt)
                    
                    CustomPicker(title: "Sherbimi", selection: $sherbim, options: Constants.sherbimet)
                    
                    CustomTextField(placeholder: "Klienti", text: $klient)
                    
                    CustomTextField(placeholder: "Pershkrimi", text: $pershkrim)
                    
                    HStack(spacing: 10) {
                        CustomNumberField(placeholder: "Sasia", value: $sasi)
                        
                        Picker("Njesi", selection: $njesi) {
                            ForEach(Constants.njesite, id: \.self) { n in
                                Text(n).tag(n)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(14)
                        .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    
                    CustomNumberField(placeholder: "Cmimi per njesi", value: $cmim)
                    
                    PreviewBox(label: "SHUMA", value: shuma.formattedLeke, color: .appGreen)
                    
                    SubmitButton(title: "RUAJ", gradient: .greenGradient) {
                        saveItem()
                    }
                }
                .padding(24)
            }
            .background(Color.cardBackground)
            .navigationTitle(isEditing ? "✏️ Ndrysho Te Ardhurë" : "+ Te Ardhure e Re")
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
                data = item.data
                muaj = item.muaj
                sherbim = item.sherbim
                klient = item.klient
                pershkrim = item.pershkrim
                sasi = item.sasi
                cmim = item.cmim
                njesi = item.njesi
            }
        }
    }
    
    func saveItem() {
        var item = existingItem ?? Ardhure()
        item.data = data
        item.muaj = muaj
        item.sherbim = sherbim
        item.klient = klient
        item.pershkrim = pershkrim
        item.sasi = sasi
        item.cmim = cmim
        item.njesi = njesi
        
        if isEditing {
            store.updateArdhure(item)
        } else {
            store.addArdhure(item)
        }
        
        dismiss()
    }
}

#Preview {
    ArdhuraView()
        .environmentObject(DataStore())
}
