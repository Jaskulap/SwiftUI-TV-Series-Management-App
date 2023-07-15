//
//  ContentView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var settings = Settings()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddView()
                .tabItem { Label("Add", systemImage: "plus") }
                .environmentObject(settings)
                .tag(0)
            
            StatisticsView()
                .tabItem { Label("Statistics", systemImage: "chart.bar.xaxis") }
                .environmentObject(settings)
                .tag(1)
            
            MainView()
                .tabItem { Label("Main", systemImage: "magnifyingglass") }
                .environmentObject(settings)
                .tag(2)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
                .environmentObject(settings)
                .tag(3)
        }
        .onAppear() {
            print("LOL")
            UITabBar.appearance().barTintColor = .darkGray
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                }
                .onEnded { gesture in
                    let minimumDistance: CGFloat = 50 // Minimalna odległość przesunięcia
                    
                    if gesture.translation.width < -minimumDistance {
                        // Swipe w lewo - przechodzenie do następnego widoku
                        selectedTab = min(selectedTab + 1, 3)
                    } else if gesture.translation.width > minimumDistance {
                        // Swipe w prawo - przechodzenie do poprzedniego widoku
                        selectedTab = max(selectedTab - 1, 0)
                    }
                }
        )

    }
}

func mapFetchedSerials(fetchedSerials:FetchedResults<SerialEntity>) -> [Serial] {
        return fetchedSerials.map { serialEntity in
            return Serial(
                obrazek: serialEntity.obrazek ?? "wyd1",
                obrazek2: serialEntity.obrazek2 ?? "wyd1",
                napis: serialEntity.napis ?? "nie poszlo",
                dodano: serialEntity.dodano,
                streszczenie: serialEntity.streszczenie ?? "nie poszlo",
                ocena: serialEntity.ocena,
                obrazekP: serialEntity.obrazekP ?? "netflix",
                tag: serialEntity.tag ?? "POPULARNE",
                iloscOdcinkow: serialEntity.iloscOdcinkow,
                sredniCzasOdcinka: serialEntity.sredniCzasOdcinka
            )
        }
    }
func mapFetchedOdcinki(fetchedOdcinki:FetchedResults<OdcinekEntity>) -> [Odcinek] {
        return fetchedOdcinki.map { odcinekEntity in
            return Odcinek(
                tytul: odcinekEntity.tytul ?? "odc_x",
                czyDodanoOdcinek: odcinekEntity.czyDodanoOdcinek
            )
        }
    }
struct BigText:View{
    let text:String
    var body:some View{
        Text(text).fontWeight(.heavy)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
