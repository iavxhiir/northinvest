//
//  ShpenzimetView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct ShpenzimetView: View {
    @EnvironmentObject var store: DataStore
    @State private var selectedMuaj = ""
    @State private var showingForm = false
    @State private var editingItem: Shpenzim?
    
    var filteredShpenzimet: [Shpenzim] {
        store.data.shpenzimet.filter { shpenzim in
            selectedMuaj.isEmpty || shpenzim.muaj == selectedMuaj
        }.reversed()
    }
    
    var filteredTotal: Double {
        filteredShpenzimet.reduce(0) { $0 + $1.shuma }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 12) {
                    // Filter
                    Picker("Muaji", selection: $selectedMuaj) {
                        Text("Te gjitha").tag("")
                        ForEach(Constants.muajt, id: \.self) { muaj in
                            Text(muaj).tag(muaj)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(red: 51/255, green: 65/255, blue: 85/255))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    
                    // Total Bar
                    TotalBar(label: "TOTALI:", value: filteredTotal.formattedLeke, color: .appOrange)
                    
                    // List
                    if filteredShpenzimet.isEmpty {
                        EmptyStateView(message: "Nuk ka te dhena", submessage: "Shtyp + per te shtuar")
                    } else {
                        ForEach(Array(filteredShpenzimet), id: \.id) { shpenzim in
                            ShpenzimListItem(shpenzim: shpenzim) {
                                editingItem = shpenzim
                                showingForm = true
                            } onDelete: {
                                store.deleteShpenzim(shpenzim)
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
                    .background(LinearGradient.orangeGradient)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .sheet(isPresented: $showingForm) {
            ShpenzimFormView(existingItem: editingItem)
        }
    }
}

struct ShpenzimListItem: View {
    let shpenzim: Shpenzim
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        ListItemCard {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(shpenzim.kategori.isEmpty ? "Pa kategori" : shpenzim.kategori)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(shpenzim.pershkrim.isEmpty ? "-" : shpenzim.pershkrim) • \(shpenzim.muaj.isEmpty ? "-" : shpenzim.muaj)")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)
                    
                    if !shpenzim.mjeti.isEmpty {
                        Text(shpenzim.mjeti)
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(shpenzim.shuma.formattedLeke)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appOrange)
                    
                    HStack(spacing: 6) {
                        ActionButton(title: "Ndrysho", color: .appBlue, action: onEdit)
                        ActionButton(title: "Fshij", color: .appRed, action: onDelete)
                    }
                }
            }
        }
    }
}

struct ShpenzimFormView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    var existingItem: Shpenzim?
    
    @State private var data = Date()
    @State private var muaj = ""
    @State private var kategori = ""
    @State private var pershkrim = ""
    @State private var mjeti = ""
    @State private var sasi: Double = 1
    @State private var cmim: Double = 0
    
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
                    
                    CustomPicker(title: "Kategoria", selection: $kategori, options: Constants.kategorite)
                    
                    CustomTextField(placeholder: "Pershkrimi / Furnitori", text: $pershkrim)
                    
                    CustomTextField(placeholder: "Mjeti / Targa", text: $mjeti)
                    
                    HStack(spacing: 10) {
                        CustomNumberField(placeholder: "Sasia", value: $sasi)
                        CustomNumberField(placeholder: "Cmimi", value: $cmim)
                    }
                    
                    PreviewBox(label: "SHUMA", value: shuma.formattedLeke, color: .appOrange)
                    
                    SubmitButton(title: "RUAJ", gradient: .orangeGradient) {
                        saveItem()
                    }
                }
                .padding(24)
            }
            .background(Color.cardBackground)
            .navigationTitle(isEditing ? "✏️ Ndrysho Shpenzim" : "+ Shpenzim i Ri")
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
                kategori = item.kategori
                pershkrim = item.pershkrim
                mjeti = item.mjeti
                sasi = item.sasi
                cmim = item.cmim
            }
        }
    }
    
    func saveItem() {
        var item = existingItem ?? Shpenzim()
        item.data = data
        item.muaj = muaj
        item.kategori = kategori
        item.pershkrim = pershkrim
        item.mjeti = mjeti
        item.sasi = sasi
        item.cmim = cmim
        
        if isEditing {
            store.updateShpenzim(item)
        } else {
            store.addShpenzim(item)
        }
        
        dismiss()
    }
}

#Preview {
    ShpenzimetView()
        .environmentObject(DataStore())
}
