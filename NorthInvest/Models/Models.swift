//
//  Models.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import Foundation

// MARK: - Constants
struct Constants {
    static let muajt = ["Janar", "Shkurt", "Mars", "Prill", "Maj", "Qershor", 
                        "Korrik", "Gusht", "Shtator", "Tetor", "Nentor", "Dhjetor"]
    static let sherbimet = ["Transport Inertesh", "Germime", "Mjete me Qira", "Ngarkime"]
    static let kategorite = ["Nafte", "Goma", "Vajra dhe Filtra", "Riparime Mekanike", 
                             "Siguracione", "Taksa Makinash", "Pjese Kembimi", "Tjeter"]
    static let njesite = ["TON", "M3", "Muaj", "Ore"]
    static let pozicionet = ["Menaxher", "Operator", "Shofer"]
    static let vitet = ["2024", "2025", "2026", "2027", "2028"]
}

// MARK: - Income Model (Te Ardhurat)
struct Ardhure: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var data: Date = Date()
    var muaj: String = ""
    var sherbim: String = ""
    var klient: String = ""
    var pershkrim: String = ""
    var sasi: Double = 0
    var cmim: Double = 0
    var njesi: String = "TON"
    
    var shuma: Double {
        sasi * cmim
    }
}

// MARK: - Expense Model (Shpenzimet)
struct Shpenzim: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var data: Date = Date()
    var muaj: String = ""
    var kategori: String = ""
    var pershkrim: String = ""
    var mjeti: String = ""
    var sasi: Double = 1
    var cmim: Double = 0
    
    var shuma: Double {
        sasi * cmim
    }
}

// MARK: - Invoice Model (Faturat)
struct Fature: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var llogari: String = "2026"
    var data: Date = Date()
    var muaj: String = ""
    var klient: String = ""
    var neto: Double = 0
    var paguar: Double = 0
    
    var tvsh: Double {
        neto * 0.2
    }
    
    var total: Double {
        neto * 1.2
    }
    
    var mbetje: Double {
        total - paguar
    }
    
    var eshtePagear: Bool {
        mbetje <= 0
    }
}

// MARK: - Salary Model (Pagat)
struct Punonjes: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var emri: String = ""
    var pozicioni: String = "Operator"
    var pagaMujore: [Double] = Array(repeating: 0, count: 12)
    
    var pagaTotale: Double {
        pagaMujore.reduce(0, +)
    }
}

// MARK: - App Data
struct AppData: Codable {
    var ardhurat: [Ardhure] = []
    var shpenzimet: [Shpenzim] = []
    var faturat: [Fature] = []
    var punonjesit: [Punonjes] = [
        Punonjes(emri: "", pozicioni: "Menaxher"),
        Punonjes(emri: "", pozicioni: "Operator"),
        Punonjes(emri: "", pozicioni: "Operator"),
        Punonjes(emri: "", pozicioni: "Shofer"),
        Punonjes(emri: "", pozicioni: "Shofer")
    ]
}
