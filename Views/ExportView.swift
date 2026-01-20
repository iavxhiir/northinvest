//
//  ExportView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct ExportView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Info
                    VStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.appBlue)
                        
                        Text("Eksporto te Dhenat")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Zgjidh çfarë dëshiron të eksportosh në format CSV")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                    
                    // Export Options
                    VStack(spacing: 12) {
                        ExportButton(
                            title: "Te Ardhurat",
                            subtitle: "\(store.data.ardhurat.count) regjistrime",
                            icon: "💰",
                            color: .appGreen
                        ) {
                            exportData { store.exportArdhurat() }
                        }
                        
                        ExportButton(
                            title: "Shpenzimet",
                            subtitle: "\(store.data.shpenzimet.count) regjistrime",
                            icon: "💸",
                            color: .appOrange
                        ) {
                            exportData { store.exportShpenzimet() }
                        }
                        
                        ExportButton(
                            title: "Faturat",
                            subtitle: "\(store.data.faturat.count) regjistrime",
                            icon: "📄",
                            color: .appBlue
                        ) {
                            exportData { store.exportFaturat() }
                        }
                        
                        ExportButton(
                            title: "Pagat",
                            subtitle: "\(store.data.punonjesit.count) punonjës",
                            icon: "👷",
                            color: .appYellow
                        ) {
                            exportData { store.exportPagat() }
                        }
                        
                        // Divider
                        Rectangle()
                            .fill(Color.borderColor)
                            .frame(height: 1)
                            .padding(.vertical, 8)
                        
                        // Export All
                        ExportButton(
                            title: "Eksporto Te Gjitha",
                            subtitle: "Raport i plotë me të gjitha të dhënat",
                            icon: "📊",
                            color: .appGreen,
                            isLarge: true
                        ) {
                            exportData { store.exportAll() }
                        }
                    }
                    
                    // Info Text
                    VStack(spacing: 8) {
                        Text("ℹ️ Informacion")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.textSecondary)
                        
                        Text("Skedarët CSV mund të hapen me Excel, Google Sheets, ose çdo program tjetër spreadsheet. Të dhënat ruhen automatikisht në pajisjen tuaj.")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                }
                .padding(20)
            }
            .background(Color.appBackground)
            .navigationTitle("Eksporto CSV")
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
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
            }
        }
        .alert("Eksportimi", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func exportData(_ exportFunction: () -> URL?) {
        if let url = exportFunction() {
            exportURL = url
            showingShareSheet = true
        } else {
            alertMessage = "Gabim gjatë eksportimit. Ju lutem provoni përsëri."
            showingAlert = true
        }
    }
}

struct ExportButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var isLarge: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(icon)
                    .font(.system(size: isLarge ? 32 : 26))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: isLarge ? 17 : 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            .padding(16)
            .background(Color.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(14)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ExportView()
        .environmentObject(DataStore())
}
