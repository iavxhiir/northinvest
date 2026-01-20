//
//  PanelView.swift
//  NorthInvest
//
//  Created by Irdi Avxhi on 20.1.26.
//

import SwiftUI

struct PanelView: View {
    @EnvironmentObject var store: DataStore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Stats Grid
                HStack(spacing: 12) {
                    StatCard(
                        label: "Te Ardhura",
                        value: store.totalArdhura.formattedLeke,
                        gradient: .greenGradient
                    )
                    
                    StatCard(
                        label: "Shpenzime",
                        value: (store.totalShpenzime + store.totalPaga).formattedLeke,
                        gradient: .orangeGradient
                    )
                }
                
                // Profit/Loss Card
                StatCard(
                    label: "Fitimi / Humbja",
                    value: store.fitimi.formattedLeke,
                    gradient: store.fitimi >= 0 ? .profitGradient : .lossGradient
                )
                
                // Income by Service
                VStack(alignment: .leading, spacing: 0) {
                    Text("Te Ardhurat sipas Sherbimit")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.appGreen)
                        .padding(.bottom, 14)
                    
                    VStack(spacing: 0) {
                        ForEach(Constants.sherbimet, id: \.self) { sherbim in
                            CategoryRow(
                                name: sherbim,
                                value: store.ardhuraSipasSherbimit(sherbim),
                                color: .appGreen
                            )
                            if sherbim != Constants.sherbimet.last {
                                Divider()
                                    .background(Color.borderColor)
                            }
                        }
                    }
                }
                .cardStyle()
                
                // Expenses by Category
                VStack(alignment: .leading, spacing: 0) {
                    Text("Shpenzimet sipas Kategorise")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.appOrange)
                        .padding(.bottom, 14)
                    
                    VStack(spacing: 0) {
                        ForEach(Constants.kategorite, id: \.self) { kategori in
                            CategoryRow(
                                name: kategori,
                                value: store.shpenzimeSipasKategorise(kategori),
                                color: .appOrange
                            )
                            Divider()
                                .background(Color.borderColor)
                        }
                        
                        // Salaries row
                        CategoryRow(
                            name: "PAGA",
                            value: store.totalPaga,
                            color: .appYellow
                        )
                    }
                }
                .cardStyle()
                
                // Monthly Overview
                VStack(alignment: .leading, spacing: 14) {
                    Text("Pasqyra Mujore")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.appBlue)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Header
                            HStack(spacing: 0) {
                                Text("Muaji")
                                    .frame(width: 80, alignment: .leading)
                                Text("Ardhura")
                                    .frame(width: 80, alignment: .trailing)
                                Text("Shpenz.")
                                    .frame(width: 80, alignment: .trailing)
                                Text("Fitimi")
                                    .frame(width: 80, alignment: .trailing)
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .padding(.vertical, 10)
                            
                            // Rows
                            ForEach(Array(Constants.muajt.enumerated()), id: \.element) { index, muaj in
                                let ardhura = store.ardhuraNeMuaj(muaj)
                                let shpenzime = store.shpenzimeNeMuaj(muaj) + store.pagaNeMuaj(index)
                                let fitim = ardhura - shpenzime
                                
                                HStack(spacing: 0) {
                                    Text(muaj)
                                        .frame(width: 80, alignment: .leading)
                                        .foregroundColor(.white)
                                    Text(ardhura.formatted)
                                        .frame(width: 80, alignment: .trailing)
                                        .foregroundColor(.appGreen)
                                    Text(shpenzime.formatted)
                                        .frame(width: 80, alignment: .trailing)
                                        .foregroundColor(.appOrange)
                                    Text(fitim.formatted)
                                        .frame(width: 80, alignment: .trailing)
                                        .foregroundColor(fitim >= 0 ? .appGreen : .appRed)
                                }
                                .font(.system(size: 13))
                                .padding(.vertical, 10)
                                
                                Divider()
                                    .background(Color.borderColor)
                            }
                        }
                    }
                }
                .cardStyle()
            }
            .padding(16)
        }
        .background(Color.appBackground)
    }
}

#Preview {
    PanelView()
        .environmentObject(DataStore())
}
