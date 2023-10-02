//
//  ContentView.swift
//  TestApp
//
//  Created by Artem Leschenko on 02.10.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            
            VStack {
                Text("Favorite")
                Picker("", selection: $vm.pickOfFav) {
                    ForEach(vm.listOfFavor, id: \.self) { element in
                            Text(element).tag(element)
                        
                    }
                }
                
                Spacer()
                HStack {
                    Text("\(vm.firstValue) -> \(vm.secondValue)")
                    Button {
                        vm.addToFav()
                    } label: {
                        Image(systemName: "star\(vm.listOfFavor.contains("\(vm.firstValue)+\(vm.secondValue)") ? ".fill": "")")
                    }

                }
                HStack {
                    TextField("", text: $vm.text1)
                        .textFieldStyle(.roundedBorder)
                    Picker("", selection: $vm.firstValue) {
                        ForEach(vm.activeValue, id: \.self) { element in
                            Text(element).tag(element)
                        }
                    }
                }
                
                HStack {
                    Text(vm.text2)
                    Spacer()
                    Picker("", selection: $vm.secondValue) {
                        ForEach(vm.activeValue, id: \.self) { element in
                            Text(element).tag(element)
                        }
                    }
                }
                
                Button  {
                    vm.fetchRate()
                } label: {
                    Text("Convert")
                        .padding(5)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(7)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }.padding()

        }
        .onAppear {
            vm.setUp()
        }
        .alert(isPresented: $vm.showError) {
            Alert(
                title: Text("Bad news"),
                message: Text(vm.errorText),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ContentView()
}
