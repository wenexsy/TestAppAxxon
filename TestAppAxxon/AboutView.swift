//
//  AboutView.swift
//  TestAppAxxon
//
//  Created by Stepashka Igorevich on 24.03.25.
//


// AboutView.swift
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About")
                .font(.title)
            Text("Информация о приложении (пока пусто)")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}