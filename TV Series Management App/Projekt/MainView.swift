//
//  MainView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @State var searchText = ""
    @EnvironmentObject var settings: Settings
    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SerialEntity.napis, ascending: true)])
        private var fetchedSerials: FetchedResults<SerialEntity>
    
    @State var selectedSerial: Serial = Serial(obrazek: "wyd1",obrazek2: "wyd1", napis: "Serial_1", dodano: false, streszczenie: "Oto stresczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)
    @State var seriale:[Serial] = []
    @State var isSerialViewPresented = false
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Wyszukiwarka(searchText: $searchText).frame(height:35)
                
                ScrollView(.vertical){
                    VStack(alignment: .leading){
                        
                        PanelLista(seriale: $seriale, selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials, viewContext: viewContext, isTagUsed: true, tytul: "POPULARNE")
                        PanelLista(seriale: $seriale, selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials,viewContext: viewContext, isTagUsed: true, tytul: "NOWOSCI")
                        PanelLista(seriale: $seriale, selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials,viewContext: viewContext, isTagUsed: true, tytul: "KLASYKI")
                        Text(searchText)
                        Spacer()
                    }.clipped()
                    
                }.onAppear{
                    print("\n\n\(mapFetchedSerials(fetchedSerials:fetchedSerials))")
                    seriale = mapFetchedSerials(fetchedSerials:fetchedSerials)
                    
                    
                }
            }
            .background(settings.kolorTla.opacity(0.75))
        }.sheet(isPresented: $isSerialViewPresented,onDismiss:{seriale = mapFetchedSerials(fetchedSerials:fetchedSerials)}){
            SerialView(selectedSerial: $selectedSerial).environmentObject(settings)
                
        }
        
    }
    
    
}

struct Serial
{
    var obrazek:String
    var obrazek2:String
    var napis:String
    var dodano:Bool
    var streszczenie:String
    var ocena:Double
    var obrazekP:String
    var tag:String
    var iloscOdcinkow:Int16
    var sredniCzasOdcinka:Int16
}

struct Odcinek
{
    var tytul:String
    var czyDodanoOdcinek:Bool
}

struct PanelView: View {
    
    @Binding var seriale:[Serial]
    @Binding var serial: Serial
    @Binding var selectedSerial:Serial
    @Binding var isSerialViewPresented: Bool
    @State var isTapped:Bool = false
    @EnvironmentObject var settings: Settings
    var fetchedSerials: FetchedResults<SerialEntity>
    var viewContext: NSManagedObjectContext
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(serial.obrazek)
                .resizable()
                .frame(width: 150, height: 200)
                .cornerRadius(8)
            ////////////////////////////////////////////////////////////////
                .onTapGesture {
                    selectedSerial = serial;
                    print(selectedSerial);
                    isSerialViewPresented=true;
                    isTapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                    {
                        isTapped = false
                    }
                }
            Color.white.opacity(isTapped ? 0.8 : 0).frame(width:150,height:200).cornerRadius(8)
            Color.black
                .opacity(0.4) // Do poprawy
                .frame(width: 150, height: 35)
                //.blur(radius: 5)
                .overlay(
                    Text(serial.napis).fontWeight(.heavy).font(.system(size:18)).foregroundColor(Color.white)
                )
            
            
            
            
            
            Button(action: {
                serial.dodano.toggle()
                if let index = fetchedSerials.firstIndex(where: { $0.napis == serial.napis }) {
                    var serialEntity = fetchedSerials[index]
                        serialEntity.dodano = serial.dodano
                        
                        // Zapisanie zmian w kontekście zarządzanym
                        do {
                            
                            print("zapis - \(serial.napis)")
                            try viewContext.save()
                            print(serialEntity)
                        } catch {
                            print("Błąd podczas zapisywania zmian: \(error)")
                        }
                    
                    }
                
                
                
            }, label: {
                Color.white.opacity(0.8)
                    .frame(width: 35, height: 35)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: serial.dodano ? "checkmark" : "plus")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
            }).offset(x: 48, y: -154)
        }
    }
}


struct PanelLista: View {
    @Binding var seriale: [Serial]
    @Binding var selectedSerial: Serial
    @Binding var isSerialViewPresented: Bool
    @EnvironmentObject var settings: Settings
    var fetchedSerials: FetchedResults<SerialEntity>
    var viewContext: NSManagedObjectContext
    var isTagUsed:Bool
    
    var tytul: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(tytul)
                .font(.title)
                .foregroundColor(settings.kolorNapisow)
                .fontWeight(.heavy)
            
            ScrollView(.horizontal) {
                
                LazyHStack {
                    if(isTagUsed){
                        ForEach(seriale.indices, id: \.self) { index in
                        if(seriale[index].tag == tytul){
                            PanelView(seriale:$seriale, serial: $seriale[index],selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials, viewContext: viewContext)
                                .frame(width: 150)
                                .foregroundColor(.white)
                            .environmentObject(settings)}
                    }}
                    else
                    {
                        ForEach(seriale.indices, id: \.self) { index in
                        
                            PanelView(seriale:$seriale, serial: $seriale[index],selectedSerial: $selectedSerial, isSerialViewPresented: $isSerialViewPresented,fetchedSerials: fetchedSerials,viewContext: viewContext)
                                .frame(width: 150)
                                .foregroundColor(.white)
                            .environmentObject(settings)
                    }
                    }
                    }
                    .frame(height: 200)
                
            }.onAppear(perform: {
                UIScrollView.appearance().bounces = false
            })
        }
        .padding(.bottom, 10)
        .padding(.leading, 5)
        
        Divider()
            .frame(height: 2)
            .background(Color.gray)
            .padding(.horizontal, 15)
    }
}


struct Wyszukiwarka:View{
    @Binding var searchText:String
    var body:some View{
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle()) .padding()
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(seriale: [Serial(obrazek: "wyd1",obrazek2: "wyd1", napis: "Serial_1", dodano: false, streszczenie: "Oto stresczenie Serialu_1. Serial ten opowiada o niczym bo jest to przykladowy serial. Nie ma fabuly, ani tworcow. Serial nie posiada rowniez zadnych fanow, bo nie istnieje",ocena:7.82,obrazekP:"netflix",tag:"akcja",iloscOdcinkow: 5, sredniCzasOdcinka: 5)])
    }
}
