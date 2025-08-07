//
//  ThirdPartySoftwareScreen.swift
//  OTPVault
//
//  Created by Lukas Grimm on 07.08.25.
//

import SwiftUI

fileprivate struct ThirdPartySoftware {
    let name: String
    let version: String
    let licenseName: String
    let license: String
}

struct ThirdPartySoftwareScreen: View {
    private static let licenses = [
        ThirdPartySoftware(
            name: "CodeScanner",
            version: "2.5.2",
            licenseName: "MIT",
            license: """
            MIT License

            Copyright (c) 2021 Paul Hudson

            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.

            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE
            """
        ),
    ];
    
    var body: some View {
        VStack {
            List {
                Section {
                    Text("This Software incorporates material provided by third parties.")
                }
                ForEach(ThirdPartySoftwareScreen.licenses, id: \.name) { tps in
                    NavigationLink("\(tps.name) (\(tps.version)) - \(tps.licenseName)") {
                        ScrollView {
                            Text(tps.license)
                                .padding()
                                .navigationTitle(Text("\(tps.name) (\(tps.version))"))
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Third Party Software"))
    }
}

#Preview {
    NavigationView {
        ThirdPartySoftwareScreen()
    }
}
