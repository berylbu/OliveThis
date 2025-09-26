//
//  TestLocComplex.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/22/25.
//

import SwiftUI
import MapKit

struct TestLocComplex: View {
    @State private var showPicker: Bool = false
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    @State private var selectedPlacemark: CLPlacemark?
    
    private func decipherIt() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: selectedCoordinates?.latitude ?? 0, longitude: selectedCoordinates?.longitude ?? 0)) { placemarks, error in
            if error == nil {
                selectedPlacemark = placemarks?[0]
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Button("Pick a Location") {
                    showPicker.toggle()
                }
                .locationPicker(isPresented: $showPicker) { coordinates in
                    if let coordinates {
                        print(coordinates)
                        selectedCoordinates = coordinates
                        decipherIt()
                        print (selectedPlacemark?.locality ?? "")
                    }
                }
            }
            .navigationTitle(Text("Custom Location Picker"))
        }
    }
}

#Preview {
    TestLocComplex()
}
