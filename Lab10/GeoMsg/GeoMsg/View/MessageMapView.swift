//
//  MessageMapView.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import MapKit
import SwiftUI

struct MessageMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.47329135396875, longitude: 19.05967702578184), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @EnvironmentObject var messageViewModel : MessageViewModel
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: messageViewModel.messages){ item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .onAppear{
            messageViewModel.fetchMessages()
        }
    }
}

#Preview {
    MessageMapView()
}
