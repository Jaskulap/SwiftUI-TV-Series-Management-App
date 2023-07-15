//
//  StatisticsView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SerialEntity.napis, ascending: true)])
        private var fetchedSerials: FetchedResults<SerialEntity>
    @State var dodaneSeriale:[Serial]=[]
    
    var czasLaczny: Int {
            var totalTime = 0
            for serial in fetchedSerials {
                if dodaneSeriale.contains(where: { $0.napis == serial.napis }) {
                    let addedEpisodesCount = serial.odcinekArray.filter { $0.czyDodanoOdcinek }.count
                    let averageEpisodeTime = serial.sredniCzasOdcinka
                    totalTime += addedEpisodesCount * Int(averageEpisodeTime)
                }
            }
            return totalTime
        }

    var body: some View {
        VStack{
            
            BigText(text: "STATYSTYKI").font(.system(size:30)).padding(.bottom,30).padding(.top,10)
            Divider()
                .frame(height: 2)
                .background(Color.gray)
                .padding(.horizontal, 15)
            HStack{
                Image(systemName: "eye").fontWeight(.bold)
                            .font(.system(size: 40))
                
                BigText(text:"DODAŁEŚ \(dodaneSeriale.count) " + (dodaneSeriale.count == 1 ? "SERIAL" : (dodaneSeriale.count >= 2 && dodaneSeriale.count <= 4 ? "SERIALE" : "SERIALI")))
                    .padding(25)

            }
            Divider()
                .frame(height: 2)
                .background(Color.gray)
                .padding(.horizontal, 15)
            HStack{
                Image(systemName: "clock").fontWeight(.bold).font(.system(size: 40))
                
                BigText(text:"SPEDZILES: \(czasLaczny) MINUT \nNA OGLADANIU SERIALI").padding(25)
            }
            Spacer()
        }.foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
            .background(settings.kolorTla.opacity(0.75))
        .onAppear{
            dodaneSeriale = mapFetchedSerials(fetchedSerials:fetchedSerials).filter {$0.dodano}
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
