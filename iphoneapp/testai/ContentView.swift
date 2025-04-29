//
//  ContentView.swift
//  testai
//
//  Created by Noah Trevino on 4/7/25.
//

import SwiftUI

struct Playlist: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let description: String
    let link: String
}

class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = [
        Playlist(title: "Rock Legends", genre: "Rock", description: "The greatest classic rock hits.", link: "https://example.com/rock"),
        Playlist(title: "Hip-Hop Vibes", genre: "Hip-Hop", description: "Hot beats and fresh rhymes.", link: "https://example.com/hiphop"),
        Playlist(title: "Pop Paradise", genre: "Pop", description: "Top pop tracks to sing along to.", link: "https://example.com/pop"),
        Playlist(title: "EDM Essentials", genre: "EDM", description: "Electronic dance anthems.", link: "https://example.com/edm"),
        Playlist(title: "Country Roads", genre: "Country", description: "Feel-good country tunes.", link: "https://example.com/country"),
        Playlist(title: "Smooth Jazz", genre: "Jazz", description: "Chill jazz for any mood.", link: "https://example.com/jazz")
    ]
}

struct ContentView: View {
    @StateObject private var viewModel = PlaylistViewModel()
    @State private var searchText: String = ""

    var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return viewModel.playlists
        } else {
            return viewModel.playlists.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("\u{1F3B5} Music Explorer")
                    .font(.largeTitle.bold())
                    .padding(.top)
                    .foregroundColor(.purple)

                TextField("Search playlists...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredPlaylists) { playlist in
                            NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                                PlaylistCardView(playlist: playlist)
                            }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct PlaylistCardView: View {
    let playlist: Playlist

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(playlist.title)
                .font(.headline)
                .foregroundColor(.white)

            Text(playlist.genre)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct PlaylistDetailView: View {
    let playlist: Playlist

    var body: some View {
        VStack(spacing: 20) {
            Text(playlist.title)
                .font(.largeTitle.bold())
                .foregroundColor(.purple)
                .padding(.top)

            Text("Genre: \(playlist.genre)")
                .font(.title2)
                .foregroundColor(.secondary)

            Text(playlist.description)
                .font(.body)
                .padding()

            Link(destination: URL(string: playlist.link)!) {
                Text("Open Playlist")
                    .font(.headline)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle(playlist.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
