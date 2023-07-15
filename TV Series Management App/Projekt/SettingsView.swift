//
//  SettingsView.swift
//  Projekt
//
//  Created by Pawel Jaskula on 28/05/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $settings.kolorTlaSwitched)
                .padding().foregroundColor(settings.kolorNapisow)
            Spacer()
        }.background(settings.kolorTla.opacity(0.75))
        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
