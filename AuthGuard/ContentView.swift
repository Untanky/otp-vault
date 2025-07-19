//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 15.07.25.
//

import SwiftData
import SwiftUI

enum Route: Hashable {
    case scan
    case createManual
    case oneTimePasswordDetails(item: OneTimePassword)
}

struct ContentView: View {
    @EnvironmentObject var authenticator: Authenticator
    @EnvironmentObject var oneTimePasswordService: OneTimePasswordService
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            StartScreen()
                .onAppear {
                    Task {
                        do {
                            try oneTimePasswordService.loadOneTimePasswords()
                        } catch {
                            print(error)
                        }
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scan:
                        ScannerView(scannedOneTimePassword: { otp in
                            do {
                                try self.oneTimePasswordService.addOneTimePassword(otp)
                            } catch {
                                print(error)
                            }
                        })
                    case .createManual:
                        CreateOneTimePasswordView(createdOtp: { otp in
                            do {
                                try self.oneTimePasswordService.addOneTimePassword(otp)
                                path.removeLast()
                            } catch {
                                print(error)
                            }
                        })
                    case .oneTimePasswordDetails(let item):
                        DetailsView(oneTimePassword: item, deleteOtp: { id in
                            do {
                                try self.oneTimePasswordService.removeOneTimePassword(byId: id)
                            } catch {
                                print(error)
                            }
                        })
                    }
                }
        }
    }
}
