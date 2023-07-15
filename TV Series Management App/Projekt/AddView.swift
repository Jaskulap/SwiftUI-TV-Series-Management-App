import SwiftUI

struct AddView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath:\SerialEntity.napis, ascending: true)],animation: .default)
    var seriale: FetchedResults<SerialEntity>
    @State var loga = ["Netflix","Amazon","HBO","Player"]
    @State var obrazek: String = "wyd1"
    @State var obrazek2: String = "wyd1"
    @State var napis: String = "Test"
    @State var dodano: Bool = false
    @State var streszczenie: String = "Serial to pełnometrażowa produkcja telewizyjna, składająca się z sezonów i odcinków. Opowiada on historię głównych bohaterów, którzy stawiają czoła różnym wyzwaniom i konfliktom, rozwijając się wraz z postępem fabuły. Serial łączy w sobie elementy dramatu, komedii, akcji, romansu lub innych gatunków, tworząc unikalną mieszankę emocji i doświadczeń dla widzów. Każdy odcinek kontynuuje fabułę, rozwijając wątki i wprowadzając nowe wydarzenia, które trzymają widzów w napięciu. Serial stanowi wciągającą podróż przez światy i historie, które przyciągają uwagę publiczności i wzbudzają ich zainteresowanie."
    @State var ocena: Double = 0.00
    @State var obrazekP: String = "Netflix"
    @State var tag: String = "POPULARNE"
    @State var iloscOdcinkow: Int16 = 0
    @State var sredniCzasOdcinka: Int16 = 0
    @State var showingPopup = false
    @State var dodano2 = false
    var tytulyM:[String] = ["Adventure Time","Barry","Breaking Bad","Game of Thrones","Hilda","Dr House","House of Dragon","Pokemon","Sailor Moon"]
    var logaM = ["Player","HBO","HBO","HBO","Netflix","Amazon","HBO","Player","Amazon"]
    var ocenaM = [9,8,10,8,7,8,8,7,7]
    var iloscOdcinkowM = [10,8,5,12,6,7,8,9,8]
    var sredniCzasM = [11,30,50,52,20,45,51,21,21]
    var tagM = ["POPULARNE","NOWOSCI","KLASYKI","KLASYKI", "NOWOSCI","KLASYKI","POPULARNE","NOWOSCI","POPULARNE"]
    func dodajSerial(obrazek:String,obrazek2:String,obrazekP:String,napis:String,streszczenie:String,ocena:Double,iloscOdcinkow:Int16,sredniCzasOdcinka:Int16,tag:String){
        
        let newSerial = SerialEntity(context: viewContext)
        newSerial.obrazek = obrazek
        newSerial.obrazek2 = obrazek2
        newSerial.obrazekP = obrazekP
        newSerial.napis = napis
        newSerial.streszczenie = streszczenie
        newSerial.ocena = ocena
        newSerial.iloscOdcinkow = iloscOdcinkow
        newSerial.sredniCzasOdcinka = sredniCzasOdcinka
        newSerial.tag = tag
        
        if (napis != "" && streszczenie != "" && ocena > 0.00 && iloscOdcinkow > 0 && sredniCzasOdcinka > 0) {
            print("Walidacja NULL przeszła")
            do {
                try viewContext.save()
                print("Serial został dodany")
            } catch {
                print("Wystąpił błąd podczas dodawania serialu: \(error.localizedDescription)")
            }
        } else {
            print("Walidacja NULL nie przeszła")
        }
    }
    func dodajOdcinek(tytul:String, serial:SerialEntity)
    {
        
        let odcinek = OdcinekEntity(context: viewContext)
        odcinek.tytul = tytul
        odcinek.czyDodanoOdcinek = false
        odcinek.toSerialEntity = serial
        do {
            try viewContext.save()
            print("Odcinek zostal dodany")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                Text("Nazwa Serialu")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Spacer()
                TextField("Podaj nazwę serialu", text: $napis)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200, alignment: .trailing) // Trzymaj się prawej strony
                    .foregroundColor(.black) // Czarny tekst
            }
            HStack {
                Text("Platforma")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Spacer()
                Menu(content: {
                    Picker("Platforma", selection: $obrazekP) {
                        ForEach(loga, id: \.self) { logo in
                            HStack {
                                Text(logo)
                                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                                Image("logo\(logo)")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }, label: {
                    Image("logo\(obrazekP)")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                }).padding(.trailing,70)
            }
            HStack {
                Text("Tag")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Spacer()
                Picker("Tag", selection: $tag) {
                    Text("POPULARNE").tag("POPULARNE").foregroundColor(settings.kolorNapisow)
                    Text("NOWOSCI").tag("NOWOSCI").foregroundColor(settings.kolorNapisow)
                    Text("KLASYKI").tag("KLASYKI").foregroundColor(settings.kolorNapisow)
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .trailing) // Trzymaj się prawej strony
                .foregroundColor(.black) // Czarny tekst
                .padding(.trailing,28)
            }
            HStack {
                Text("Ocena")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Spacer()
                TextField("Podaj ocenę", value: $ocena, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200, alignment: .trailing) // Trzymaj się prawej strony
                    .foregroundColor(.black) // Czarny tekst
            }
            HStack {
                Text("Ilość odcinków")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Spacer()
                TextField("Podaj ilość odcinków", value: $iloscOdcinkow, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200, alignment: .trailing) // Trzymaj się prawej strony
                    .foregroundColor(.black) // Czarny tekst
            }
            HStack {
                Text("Średni czas odcinka: \(sredniCzasOdcinka)")
                    .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
                Slider(value: Binding<Double>(get: {
                    Double(sredniCzasOdcinka)
                }, set: { newValue in
                    sredniCzasOdcinka = Int16(newValue)
                }), in: 5...90, step: 1)
            }
            .padding(.vertical)
            
                Button(action: {
                    let serialExists = seriale.contains { $0.napis == napis }
                    if serialExists {
                        print("Serial o podanym napisie już istnieje.")
                        return
                    }
                    else{
                        print(transformString(input: napis, znak: "1"))
                        dodajSerial(obrazek: transformString(input: napis, znak: "1"),
                                    obrazek2: transformString(input: napis, znak: "2"),
                                    obrazekP: "logo\(obrazekP)",
                                    napis: napis,
                                    streszczenie: streszczenie,
                                    ocena: ocena,
                                    iloscOdcinkow: iloscOdcinkow,
                                    sredniCzasOdcinka: sredniCzasOdcinka,
                                    tag: tag)
                        showingPopup = true
                        if let newSerial = seriale.first(where: { $0.napis == napis }) {
                            for index in 0..<Int(iloscOdcinkow) {
                                let tytul = napis + " " + String(index+1)
                                print(tytul)
                                dodajOdcinek(tytul: tytul, serial: newSerial)
                            }
                        }
                    }}) {
                        Text("DODAJ")
                            .frame(width: 100, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
            Spacer()
            

        }
        .foregroundColor(settings.kolorNapisow) // Ustawienie koloru tekstu
        .background(settings.kolorTla.opacity(0.75))
        .onAppear{
            if(dodano2 == false){
                for i in 0 ..< 9{
                    let serialExists = seriale.contains { $0.napis == tytulyM[i]}
                    if serialExists {
                        print("Serial \(tytulyM[i]) już istnieje.")
                    }
                    else{
                        dodajSerial(obrazek: transformString(input: tytulyM[i], znak: "1"), obrazek2: transformString(input: tytulyM[i], znak: "2"), obrazekP: "logo\(logaM[i])", napis: tytulyM[i], streszczenie: streszczenie, ocena: Double(ocenaM[i]), iloscOdcinkow: Int16(iloscOdcinkowM[i]), sredniCzasOdcinka: Int16(sredniCzasM[i]), tag: tagM[i])
                        if let newSerial = seriale.first(where: { $0.napis == tytulyM[i] }) {
                            for index in 0..<Int(iloscOdcinkowM[i]) {
                                let tytul = tytulyM[i] + " " + String(index+1)
                                print(tytul)
                                dodajOdcinek(tytul: tytul, serial: newSerial)
                            }
                        }
                    }
                }
            }
            dodano2 = true
        }
    }

    func transformString(input: String,znak:String) -> String {
        let lowercaseString = input.lowercased()
        let trimmedString = lowercaseString.replacingOccurrences(of: " ", with: "")
        let transformedString = trimmedString + znak
        return transformedString
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
