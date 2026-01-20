//
//  DataStore.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import Foundation
import SwiftUI
import Combine

class DataStore: ObservableObject {
    @Published var data: AppData
    @Published var lastSaved: Date?
    @Published var isSaving: Bool = false
    
    private let fileName = "NorthInvestData.json"
    private var saveDebouncer: AnyCancellable?
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    init() {
        // Initialize with empty data first
        self.data = AppData()
        
        // Then load saved data
        loadData()
        
        // Set up auto-save whenever data changes (with debounce to avoid too many writes)
        setupAutoSave()
    }
    
    private func setupAutoSave() {
        saveDebouncer = $data
            .dropFirst() // Skip initial value
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.save()
            }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Try to load from Documents directory first (primary storage)
        if let loadedData = loadFromFile() {
            self.data = loadedData
            self.lastSaved = getFileModificationDate()
            print("✅ Të dhënat u ngarkuan nga Documents (\(data.ardhurat.count) ardhura, \(data.shpenzimet.count) shpenzime)")
            return
        }
        
        // Fallback: Try UserDefaults for migration from old version
        if let savedData = UserDefaults.standard.data(forKey: "northinvest"),
           let decoded = try? JSONDecoder().decode(AppData.self, from: savedData) {
            self.data = decoded
            save() // Migrate to file storage
            UserDefaults.standard.removeObject(forKey: "northinvest") // Clean up old storage
            print("✅ Të dhënat u migruan nga UserDefaults në Documents")
            return
        }
        
        // Also check old key
        if let savedData = UserDefaults.standard.data(forKey: "NorthInvestData"),
           let decoded = try? JSONDecoder().decode(AppData.self, from: savedData) {
            self.data = decoded
            save()
            UserDefaults.standard.removeObject(forKey: "NorthInvestData")
            print("✅ Të dhënat u migruan")
            return
        }
        
        print("📁 Fillim i ri - nuk ka të dhëna të ruajtura")
    }
    
    private func loadFromFile() -> AppData? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("📁 Skedari nuk ekziston: \(fileURL.path)")
            return nil
        }
        
        do {
            let fileData = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(AppData.self, from: fileData)
            return decoded
        } catch {
            print("❌ Gabim në ngarkim: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getFileModificationDate() -> Date? {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modDate = attributes[.modificationDate] as? Date else {
            return nil
        }
        return modDate
    }
    
    // MARK: - Data Saving
    func save() {
        isSaving = true
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // Makes debugging easier
            let encoded = try encoder.encode(data)
            try encoded.write(to: fileURL, options: [.atomic])
            
            lastSaved = Date()
            print("✅ Ruajtur automatike: \(Date().formatted(date: .omitted, time: .standard))")
        } catch {
            print("❌ GABIM: Të dhënat NUK u ruajtën! \(error.localizedDescription)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSaving = false
        }
    }
    
    // Force save (for when app goes to background)
    func forceSave() {
        saveDebouncer?.cancel()
        save()
    }
    
    // MARK: - Computed Properties
    var totalArdhura: Double {
        data.ardhurat.reduce(0) { $0 + $1.shuma }
    }
    
    var totalShpenzime: Double {
        data.shpenzimet.reduce(0) { $0 + $1.shuma }
    }
    
    var totalPaga: Double {
        data.punonjesit.reduce(0) { $0 + $1.pagaTotale }
    }
    
    var fitimi: Double {
        totalArdhura - totalShpenzime - totalPaga
    }
    
    // MARK: - Ardhurat Methods
    func addArdhure(_ ardhure: Ardhure) {
        data.ardhurat.append(ardhure)
    }
    
    func updateArdhure(_ ardhure: Ardhure) {
        if let index = data.ardhurat.firstIndex(where: { $0.id == ardhure.id }) {
            data.ardhurat[index] = ardhure
        }
    }
    
    func deleteArdhure(_ ardhure: Ardhure) {
        data.ardhurat.removeAll { $0.id == ardhure.id }
    }
    
    func ardhuraSipasSherbimit(_ sherbim: String) -> Double {
        data.ardhurat.filter { $0.sherbim == sherbim }.reduce(0) { $0 + $1.shuma }
    }
    
    // MARK: - Shpenzimet Methods
    func addShpenzim(_ shpenzim: Shpenzim) {
        data.shpenzimet.append(shpenzim)
    }
    
    func updateShpenzim(_ shpenzim: Shpenzim) {
        if let index = data.shpenzimet.firstIndex(where: { $0.id == shpenzim.id }) {
            data.shpenzimet[index] = shpenzim
        }
    }
    
    func deleteShpenzim(_ shpenzim: Shpenzim) {
        data.shpenzimet.removeAll { $0.id == shpenzim.id }
    }
    
    func shpenzimeSipasKategorise(_ kategori: String) -> Double {
        data.shpenzimet.filter { $0.kategori == kategori }.reduce(0) { $0 + $1.shuma }
    }
    
    // MARK: - Faturat Methods
    func addFature(_ fature: Fature) {
        data.faturat.append(fature)
    }
    
    func updateFature(_ fature: Fature) {
        if let index = data.faturat.firstIndex(where: { $0.id == fature.id }) {
            data.faturat[index] = fature
        }
    }
    
    func deleteFature(_ fature: Fature) {
        data.faturat.removeAll { $0.id == fature.id }
    }
    
    func updatePaguar(faturaId: UUID, paguar: Double) {
        if let index = data.faturat.firstIndex(where: { $0.id == faturaId }) {
            data.faturat[index].paguar = paguar
        }
    }
    
    // MARK: - Pagat Methods
    func updatePunonjes(_ punonjes: Punonjes) {
        if let index = data.punonjesit.firstIndex(where: { $0.id == punonjes.id }) {
            data.punonjesit[index] = punonjes
        }
    }
    
    func updatePaga(punonjesId: UUID, muajIndex: Int, vlera: Double) {
        if let index = data.punonjesit.firstIndex(where: { $0.id == punonjesId }) {
            data.punonjesit[index].pagaMujore[muajIndex] = vlera
        }
    }
    
    // MARK: - Monthly Data
    func ardhuraNeMuaj(_ muaj: String) -> Double {
        data.ardhurat.filter { $0.muaj == muaj }.reduce(0) { $0 + $1.shuma }
    }
    
    func shpenzimeNeMuaj(_ muaj: String) -> Double {
        data.shpenzimet.filter { $0.muaj == muaj }.reduce(0) { $0 + $1.shuma }
    }
    
    func pagaNeMuaj(_ muajIndex: Int) -> Double {
        data.punonjesit.reduce(0) { $0 + $1.pagaMujore[muajIndex] }
    }
    
    func fitimiNeMuaj(_ muaj: String, muajIndex: Int) -> Double {
        ardhuraNeMuaj(muaj) - shpenzimeNeMuaj(muaj) - pagaNeMuaj(muajIndex)
    }
    
    // MARK: - CSV Export
    func exportArdhurat() -> URL? {
        var csv = "Data,Muaji,Sherbimi,Klienti,Pershkrimi,Sasia,Njesia,Cmimi,Shuma\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for item in data.ardhurat {
            let row = [
                dateFormatter.string(from: item.data),
                item.muaj,
                item.sherbim,
                item.klient.replacingOccurrences(of: ",", with: ";"),
                item.pershkrim.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.sasi),
                item.njesi,
                String(format: "%.0f", item.cmim),
                String(format: "%.0f", item.shuma)
            ].joined(separator: ",")
            csv += row + "\n"
        }
        
        return saveCSV(content: csv, fileName: "TeArdhurat_\(currentDateString()).csv")
    }
    
    func exportShpenzimet() -> URL? {
        var csv = "Data,Muaji,Kategoria,Pershkrimi,Mjeti,Sasia,Cmimi,Shuma\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for item in data.shpenzimet {
            let row = [
                dateFormatter.string(from: item.data),
                item.muaj,
                item.kategori,
                item.pershkrim.replacingOccurrences(of: ",", with: ";"),
                item.mjeti.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.sasi),
                String(format: "%.0f", item.cmim),
                String(format: "%.0f", item.shuma)
            ].joined(separator: ",")
            csv += row + "\n"
        }
        
        return saveCSV(content: csv, fileName: "Shpenzimet_\(currentDateString()).csv")
    }
    
    func exportFaturat() -> URL? {
        var csv = "Llogaria,Data,Muaji,Klienti,Neto,TVSH,Total,Paguar,Mbetje,Statusi\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for item in data.faturat {
            let row = [
                item.llogari,
                dateFormatter.string(from: item.data),
                item.muaj,
                item.klient.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.neto),
                String(format: "%.0f", item.tvsh),
                String(format: "%.0f", item.total),
                String(format: "%.0f", item.paguar),
                String(format: "%.0f", item.mbetje),
                item.eshtePagear ? "Paguar" : "Papaguar"
            ].joined(separator: ",")
            csv += row + "\n"
        }
        
        return saveCSV(content: csv, fileName: "Faturat_\(currentDateString()).csv")
    }
    
    func exportPagat() -> URL? {
        var csv = "Emri,Pozicioni," + Constants.muajt.joined(separator: ",") + ",Totali\n"
        
        for item in data.punonjesit {
            var row = [
                item.emri.isEmpty ? "Pa emer" : item.emri.replacingOccurrences(of: ",", with: ";"),
                item.pozicioni
            ]
            row += item.pagaMujore.map { String(format: "%.0f", $0) }
            row.append(String(format: "%.0f", item.pagaTotale))
            csv += row.joined(separator: ",") + "\n"
        }
        
        return saveCSV(content: csv, fileName: "Pagat_\(currentDateString()).csv")
    }
    
    func exportAll() -> URL? {
        var csv = "=== TE ARDHURAT ===\n"
        csv += "Data,Muaji,Sherbimi,Klienti,Pershkrimi,Sasia,Njesia,Cmimi,Shuma\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for item in data.ardhurat {
            let row = [
                dateFormatter.string(from: item.data),
                item.muaj,
                item.sherbim,
                item.klient.replacingOccurrences(of: ",", with: ";"),
                item.pershkrim.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.sasi),
                item.njesi,
                String(format: "%.0f", item.cmim),
                String(format: "%.0f", item.shuma)
            ].joined(separator: ",")
            csv += row + "\n"
        }
        csv += "TOTALI TE ARDHURAT:,,,,,,,," + String(format: "%.0f", totalArdhura) + "\n\n"
        
        csv += "=== SHPENZIMET ===\n"
        csv += "Data,Muaji,Kategoria,Pershkrimi,Mjeti,Sasia,Cmimi,Shuma\n"
        
        for item in data.shpenzimet {
            let row = [
                dateFormatter.string(from: item.data),
                item.muaj,
                item.kategori,
                item.pershkrim.replacingOccurrences(of: ",", with: ";"),
                item.mjeti.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.sasi),
                String(format: "%.0f", item.cmim),
                String(format: "%.0f", item.shuma)
            ].joined(separator: ",")
            csv += row + "\n"
        }
        csv += "TOTALI SHPENZIMET:,,,,,,," + String(format: "%.0f", totalShpenzime) + "\n\n"
        
        csv += "=== FATURAT ===\n"
        csv += "Llogaria,Data,Muaji,Klienti,Neto,TVSH,Total,Paguar,Mbetje,Statusi\n"
        
        for item in data.faturat {
            let row = [
                item.llogari,
                dateFormatter.string(from: item.data),
                item.muaj,
                item.klient.replacingOccurrences(of: ",", with: ";"),
                String(format: "%.0f", item.neto),
                String(format: "%.0f", item.tvsh),
                String(format: "%.0f", item.total),
                String(format: "%.0f", item.paguar),
                String(format: "%.0f", item.mbetje),
                item.eshtePagear ? "Paguar" : "Papaguar"
            ].joined(separator: ",")
            csv += row + "\n"
        }
        csv += "\n"
        
        csv += "=== PAGAT ===\n"
        csv += "Emri,Pozicioni," + Constants.muajt.joined(separator: ",") + ",Totali\n"
        
        for item in data.punonjesit {
            var row = [
                item.emri.isEmpty ? "Pa emer" : item.emri.replacingOccurrences(of: ",", with: ";"),
                item.pozicioni
            ]
            row += item.pagaMujore.map { String(format: "%.0f", $0) }
            row.append(String(format: "%.0f", item.pagaTotale))
            csv += row.joined(separator: ",") + "\n"
        }
        csv += "TOTALI PAGAT:,," + String(repeating: ",", count: 11) + String(format: "%.0f", totalPaga) + "\n\n"
        
        csv += "=== PERMBLEDHJE ===\n"
        csv += "Te Ardhurat," + String(format: "%.0f", totalArdhura) + "\n"
        csv += "Shpenzimet," + String(format: "%.0f", totalShpenzime) + "\n"
        csv += "Pagat," + String(format: "%.0f", totalPaga) + "\n"
        csv += "FITIMI/HUMBJA," + String(format: "%.0f", fitimi) + "\n"
        
        return saveCSV(content: csv, fileName: "NorthInvest_Raporti_\(currentDateString()).csv")
    }
    
    private func saveCSV(content: String, fileName: String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("❌ Gabim në eksportim CSV: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }
}
