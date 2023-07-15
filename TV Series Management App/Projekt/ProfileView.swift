//
//  ProfileView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 29/05/2023.
//

import SwiftUI

struct ProfileView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SerialEntity.napis, ascending: true)])
        private var fetchedSerials: FetchedResults<SerialEntity>
    
    
    @State var profil:Profil=Profil(imie: "Jaskulapa", obrazekIndex: 1)
    
    @EnvironmentObject var settings: Settings
    @State var selectedSerial: Serial = Serial(obrazek: "wyd1",obrazek2: "wyd1", napis: "Serial_1", dodano: false, streszczenie: "Oto stresczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)
    @State var isSerialViewPresented = false
    @State var seriale:[Serial]=[]
    
    @State var dodaneSeriale: [Serial]=[]
    var body: some View {
        NavigationView{
        VStack{
            Spacer()
            Image("profil"+"\(profil.obrazekIndex)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle()) // Przycięcie w kształt koła
                .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 4)) // Obramowanie koła
                .shadow(radius: 3)
                .onLongPressGesture(minimumDuration: 1.0) {
                    
                        profil.obrazekIndex = (profil.obrazekIndex + 1) % 3
                    
                }
            
            
            
            BigText(text:"Witaj  \(profil.imie)").font(.system(size:22)).foregroundColor(settings.kolorNapisow)
            Spacer()
            NavigationLink(destination:SettingsView()){BigText(text:"USTAWIENIA").font(.system(size:22)).foregroundColor(settings.kolorNapisow).frame(width:150,height:80).background(settings.kolorNapisow.opacity(0.5)).cornerRadius(15)}
            Spacer()
            Spacer()
            PanelLista(seriale: $dodaneSeriale, selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials, viewContext:viewContext, isTagUsed: false, tytul: "DODANE")
            
        }.background(settings.kolorTla.opacity(0.75))
        .onAppear{
            seriale = mapFetchedSerials(fetchedSerials:fetchedSerials)
            dodaneSeriale = seriale.filter { $0.dodano }
        }.onDisappear {
            seriale = mapFetchedSerials(fetchedSerials:fetchedSerials)
        }
        
        }.sheet(isPresented: $isSerialViewPresented,onDismiss:{seriale = mapFetchedSerials(fetchedSerials:fetchedSerials);dodaneSeriale = seriale.filter { $0.dodano }}){
            SerialView(selectedSerial: $selectedSerial).environmentObject(settings)}
        
    }
    
}

struct Profil{
    var imie:String
    var obrazekIndex:Int
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(seriale: [Serial(obrazek: "wyd1",obrazek2: "wyd1", napis: "Serial_1", dodano: false, streszczenie: "Oto stresczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)])
    }
}
