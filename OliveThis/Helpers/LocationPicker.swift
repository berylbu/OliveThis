//
//  LocationPicker.swift
//  OliveThis
//
//  Created by Beryl Bucher on 9/22/25.
//

import SwiftUI
import CoreLocation
import MapKit

extension View {
    func locationPicker(isPresented: Binding<Bool>, coordinates: @escaping (CLLocationCoordinate2D?) -> ()) -> some View {
        self
            .fullScreenCover(isPresented: isPresented) {
                LocationPickerView(isPresented: isPresented, coordinates: coordinates)
            }
    }
}

fileprivate struct LocationPickerView: View {
    @Binding var isPresented: Bool
    var coordinates: (CLLocationCoordinate2D?) -> ()
    /// View Properties
    @StateObject private var manager: LocationManager = .init()
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    /// Environment Properties
    @Namespace private var mapSpace
    @FocusState private var isKeyboardActive: Bool
    @Environment(\.openURL) private var openURL
    var body: some View {
        ZStack {
            if let isPermissionDenied = manager.isPermissionDenied {
                if isPermissionDenied {
                    NoPermissionView()
                } else {
                    ZStack {
                        SearchResultsView()
                        
                        MapView()
                            .safeAreaInset(edge: .bottom, spacing: 0) {
                                SelectLocationButton()
                            }
                            .opacity(manager.showSearchResults ? 0 : 1)
                            .ignoresSafeArea(.keyboard, edges: .all)
                    }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        MapSearchBar()
                    }
                }
            } else {
                Group {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                    
                    ProgressView()
                }
            }
        }
        .onAppear(perform: manager.requestUserLocation)
        .animation(.easeInOut(duration: 0.25), value: manager.showSearchResults)
    }
    
    /// User Permission Denied View
    @ViewBuilder
    func NoPermissionView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            Text("Please allow location permission\nin the app settings!")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            /// Close Button
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .padding(15)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            /// Try Again and Go to Settings Button (Via OPENURL)
            VStack(spacing: 12) {
                Button("Try Again", action: manager.requestUserLocation)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                
                Button {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingsURL)
                    }
                } label: {
                    Text("Go to Settings")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(.background)
                        .background(Color.primary, in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            }
        }
    }
    
    /// Map View
    @ViewBuilder
    func MapView() -> some View {
        Map(position: $manager.position) {
            UserAnnotation()
        }
        .mapControls {
            /// In-Built Map Controls
            MapUserLocationButton(scope: mapSpace)
            MapCompass(scope: mapSpace)
            MapPitchToggle(scope: mapSpace)
        }
        .overlay {
            Image(systemName: "pin.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundStyle(.red.gradient)
                /// Centering the pin
                .offset(y: -17)
                .allowsHitTesting(false)
        }
        .mapScope(mapSpace)
        .onMapCameraChange { ctx in
            manager.currentRegion = ctx.region
            selectedCoordinates = ctx.region.center
        }
    }
    
    /// Map Search Bar
    @ViewBuilder
    func MapSearchBar() -> some View {
        VStack(spacing: 15) {
            Text("Select Location")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        if manager.showSearchResults {
                            isKeyboardActive = false
                            manager.clearSearch()
                            manager.showSearchResults = false
                        } else {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                            .contentShape(.rect)
                    }
                }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Search", text: $manager.searchText)
                    .padding(.vertical, 10)
                    .focused($isKeyboardActive)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        /// If empty search text then clearing the search results otherwise searching for relavant places
                        if manager.searchText.isEmpty {
                            manager.clearSearch()
                        } else {
                            manager.searchForPlaces()
                        }
                    }
                    .onChange(of: isKeyboardActive) { oldValue, newValue in
                        if newValue {
                            manager.showSearchResults = true
                        }
                    }
                    .contentShape(.rect)
                
                if manager.showSearchResults && !manager.searchText.isEmpty {
                    Button {
                        /// Only clearing search data
                        manager.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    .opacity(manager.isSearching ? 0 : 1)
                    .overlay {
                        ProgressView()
                            .opacity(manager.isSearching ? 1 : 0)
                    }
                }
            }
            .padding(.horizontal, 15)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    /// Selection Location Button
    @ViewBuilder
    func SelectLocationButton() -> some View {
        Button {
            isPresented = false
            coordinates(selectedCoordinates)
        } label: {
            Text("Select Location")
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
        }
        .padding(15)
        .background(.background)
    }
    
    /// Map Search Results
    @ViewBuilder
    func SearchResultsView() -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(manager.searchResults, id: \.self) { placemark in
                    SearchResultCardView(placemark)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }
    
    /// Search Result Card View
    @ViewBuilder
    func SearchResultCardView(_ placemark: MKPlacemark) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(placemark.name ?? "")
                    
                    Text(placemark.title ?? placemark.subtitle ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "checkmark")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .opacity(manager.selectedResult == placemark ? 1 : 0)
            }
            
            Divider()
        }
        .contentShape(.rect)
        .onTapGesture {
            isKeyboardActive = false
            /// Updating Map Position
            manager.updateMapPosition(placemark)
        }
    }
}

/// Observable Object for Location Manager
fileprivate class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isPermissionDenied: Bool?
    /// Map Properties
    @Published var currentRegion: MKCoordinateRegion?
    @Published var position: MapCameraPosition = .automatic
    @Published var userCoordinates: CLLocationCoordinate2D?
    /// Search Properties
    @Published var searchText: String = ""
    @Published var searchResults: [MKPlacemark] = []
    @Published var selectedResult: MKPlacemark?
    @Published var showSearchResults: Bool = false
    @Published var isSearching: Bool = false
    
    private var manager: CLLocationManager = .init()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    /// Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        guard status != .notDetermined else { return }
        
        isPermissionDenied = status == .denied
        if status != .denied {
            /// Fetch Location
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else { return }
        
        /// Updating User Coordinates and Map Camera Position
        userCoordinates = coordinates
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        position = .region(region)
        
        /// Stopping Updates
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        /// HANDLE ERRORS
    }
    
    /// Additional Helper Methods
    func requestUserLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func searchForPlaces() {
        /// Current Region based Search
        guard let currentRegion else { return }
        
        Task { @MainActor in
            isSearching = true
            
            let request = MKLocalSearch.Request()
            request.region = currentRegion
            request.naturalLanguageQuery = searchText
            /// Customize more as per your needs!
            guard let response = try? await MKLocalSearch(request: request).start() else {
                isSearching = false
                return
            }
            
            searchResults = response.mapItems.compactMap({ $0.placemark })
            isSearching = false
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        selectedResult = nil
    }
    
    func updateMapPosition(_ placemark: MKPlacemark) {
        let coordinates = placemark.coordinate
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        position = .region(region)
        selectedResult = placemark
        showSearchResults = false
    }
    
    deinit {
        manager.stopUpdatingLocation()
    }
}
