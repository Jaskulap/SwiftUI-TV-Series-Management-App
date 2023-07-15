//
//  SerialView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI

struct SerialView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SerialEntity.napis, ascending: true)])
        private var fetchedSerials: FetchedResults<SerialEntity>
    
    @Binding var selectedSerial: Serial
    @State var seriale: [Serial] = []
    @EnvironmentObject var settings: Settings
    @State var isInfo:Bool = true
    @State private var addedEpisodes: Set<Int> = []
    @State var watchedEpisodesCount = 0

    var body: some View {
        VStack{
            ZStack{
                Image(selectedSerial.obrazek2).resizable().frame(width:375,height:220)
                Color.black.frame(width:230,height:40).opacity(0.4).cornerRadius(23).offset(x:-100,y:90)
                Text(selectedSerial.napis).foregroundColor(Color.white).fontWeight(.heavy).font(Font.system(size:20)).offset(x:-95,y:90)
                Button(action: {
                    selectedSerial.dodano.toggle()
                    if let index = seriale.firstIndex(where: { $0.napis == selectedSerial.napis }) {
                        var serialEntity = fetchedSerials[index]
                        serialEntity.dodano = selectedSerial.dodano
                        do {
                            print("zapis - \(serialEntity.napis) \(serialEntity.dodano)")
                            try viewContext.save()
                        } catch {
                            print("Błąd podczas zapisywania zmian: \(error)")
                        }
                    }
                }, label: {
                    Color.white.opacity(0.5)
                        .frame(width: 35, height: 35)
                        .cornerRadius(40)
                        .overlay(
                            Image(systemName: selectedSerial.dodano ? "checkmark" : "plus")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.white, lineWidth: 1)
                        )}).offset(x:170,y:88)
            }.onAppear{
                print(selectedSerial)
                seriale = mapFetchedSerials(fetchedSerials:fetchedSerials)}
            
            VStack{
            HStack{
                Button(action:{isInfo = true},label:{
                    Text("INFO").frame(width:200,height:40).background(Color.white.opacity(isInfo ? 0.4 : 0.2))
                        .overlay(
                            Rectangle()
                                .stroke(Color.black.opacity(0.5), lineWidth: 2)
                        )
                        .offset(x:3,y:-12).foregroundColor(Color.white).fontWeight(.heavy).font(Font.system(size:24))
                    
                })
                Button(action:{isInfo = false},label:{
                    Text("ODCINKI").frame(width:200,height:40).background(Color.white.opacity(!isInfo ? 0.4 : 0.2)).overlay(
                        Rectangle()
                            .stroke(Color.black.opacity(0.5), lineWidth: 2)
                    ).offset(x:-5,y:-12).foregroundColor(Color.white).fontWeight(.heavy).font(Font.system(size:24))
                    
                })
            }
            
            if(isInfo){
                InfoView(selectedSerial: selectedSerial)//.offset(x:0,y:-100)
            }
            else
            {
                if let selectedSerialF = fetchedSerials.first(where: { $0.napis == selectedSerial.napis }) {
                    ScrollView {
                        if(selectedSerial.dodano){
                            Text("OBEJRZANO \(watchedEpisodesCount) z \(selectedSerialF.odcinekArray.count) ODCINKOW!")
                            .fontWeight(.heavy).foregroundColor(Color.white)}
                        ForEach(selectedSerialF.odcinekArray.indices) { index in
                            let odcinek = selectedSerialF.odcinekArray[index]
                            HStack {
                                Text(odcinek.tytul ?? "")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.heavy)
                                    .font(.system(size: 20))
                                    .padding(.leading,selectedSerial.dodano ? 20:0).frame(width:220,height:50)
                                    
                                    
                                if selectedSerial.dodano {
                                    Button(action: {
                                        selectedSerialF.odcinekArray[index].czyDodanoOdcinek.toggle()
                                        let episodeIndex = selectedSerialF.odcinekArray.indices.filter { selectedSerialF.odcinekArray[$0].czyDodanoOdcinek }
                                        addedEpisodes = Set(episodeIndex)
                                        updateWatchedEpisodesCount(selectedSerialF: selectedSerialF)
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            print("Błąd podczas zapisywania zmian: \(error)")
                                        }
                                    }) {
                                        (
                                            addedEpisodes.contains(index) ? Color.green.opacity(0.5) : Color.red.opacity(0.5)
                                        )
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(40)
                                        .overlay(
                                            Image(systemName: addedEpisodes.contains(index) ? "checkmark" : "plus")
                                                .font(.system(size: 25))
                                                .foregroundColor(.white)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 40)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing).padding(.trailing, 20)
                                }

                            }.frame(width:300,height:50).background(Color.white.opacity((0.2))).cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        updateWatchedEpisodesCount(selectedSerialF: selectedSerialF)
                        }

                }


            }
                
            }
        }.background(Color.black.opacity(0.75))//settings.kolorTla.opacity(0.75))
    }
    
    func updateWatchedEpisodesCount(selectedSerialF: SerialEntity) {
        let episodeIndex = selectedSerialF.odcinekArray.indices.filter { selectedSerialF.odcinekArray[$0].czyDodanoOdcinek }
        addedEpisodes = Set(episodeIndex)
        watchedEpisodesCount = episodeIndex.count
    }
}


struct InfoView:View{
    var selectedSerial:Serial
    var body:some View{
        ScrollView{
        Spacer()
        HStack
        {
            
            HStack
            {
                Text("OBEJRZYJ NA:").fontWeight(.heavy).foregroundColor(Color.white).padding(.leading,15)
                Image(selectedSerial.obrazekP).resizable().frame(width:35,height:35)
            }
            Spacer()
            HStack{Text("OCENA IMDB:").fontWeight(.heavy).foregroundColor(Color.white)
                Text(String(selectedSerial.ocena)).fontWeight(.heavy).foregroundColor(Color.white).padding(.trailing,15)}
        }
        
        Divider()
            .frame(height: 2)
            .background(Color.gray)
            .padding(.horizontal, 15)
        
        VStack(alignment:.leading)
        {
            Text("STRESZCZENIE:\n").fontWeight(.heavy).foregroundColor(Color.white)//settings.kolorNapisow)
            Text(selectedSerial.streszczenie).frame(width:350).foregroundColor(Color.white).fontWeight(.bold)//settings.kolorNapisow)
            
        }.padding(12)
        
    } }
}

struct SerialView_Previews: PreviewProvider {
    static var previews: some View {
        SerialView(selectedSerial: .constant(Serial(obrazek: "wyd1",obrazek2:"wyd1", napis: "Przykładowy Serial", dodano: false, streszczenie: "Oto streszczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)),
                   
                   seriale:[Serial(obrazek: "wyd1",obrazek2:"wyd1", napis: "Przykładowy Serial", dodano: false, streszczenie: "Oto streszczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)])
    }
}
