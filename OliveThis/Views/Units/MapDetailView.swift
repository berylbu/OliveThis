//
//  MapDetailView.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/26/25.
//
import SwiftUI
import MapKit

struct MapDetailView: View {
    
    let latitude: Double
    let longitude: Double
    let locationName: String
    
    @State private var cameraPosition: MapCameraPosition
    @State private var isInteractive = false
    
    init(latitude: Double, longitude: Double, locationName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        )))
    }
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: isInteractive ? .all : []) {
            Marker(locationName, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
                    withAnimation {
                        isInteractive = true
                    }
                }
    }
}

#Preview {
    MapDetailView(latitude: 37.7749, longitude: -122.4194, locationName: "location") // San Francisco
}
