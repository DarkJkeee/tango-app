//
//  MoviePage.swift
//  Tango
//
//  Created by Глеб Бурштейн on 20.12.2020.
//

import UIKit
import Combine
import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct MoviePage: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var keyboardHeight: CGFloat = 0
    @StateObject var movieVM = MoviePageViewModel()
    
    var movie: Movie
    @State var isShowingVideo = false
    @State var player: AVPlayer?
    
    var body: some View {
        ScrollView {
            NavigationLink(destination:
                            AVPlayerView(avPlayer: $player)
                            .onAppear() {
                                player?.play()
                            }
                            .onDisappear() {
                                player?.pause()
                            }, isActive: $isShowingVideo, label: {
                                EmptyView()
                            })
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .bottom) {
                    WebImage(url: URL(string: movie.descImage))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5)
                    Rectangle()
                        .frame(height: 80)
                        .opacity(0.25)
                        .blur(radius: 10)
                }
                MovieDescription(movie: movie, isShowingVideo: $isShowingVideo, player: $player)
                
                Section(header: Text("Comments").font(.custom("Dosis-Bold", size: 24)).foregroundColor(colorScheme == .dark ? .AccentColorLight: .AccentColorDark)) {
                    VStack {
                        TextBar(text: $movieVM.review, placeholder: "Comment", imageName: "pencil", isSecureField: false)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(colorScheme == .dark ? Color.AccentColorLight : Color.AccentColorDark, lineWidth: 1)
                            )

                        BorderedButton(text: "Post", color: colorScheme == .dark ? .AccentColorLight : .AccentColorDark, isOn: false, width: 80, height: 40) {
                            movieVM.addCommment(id: movie.id)
                        }
                    }
                    .padding()
                }
                .padding()
                
                ForEach(movieVM.currentComments) { comment in
                    Divider()
                    CommentView(movieVM: movieVM, comment: comment)
                }
                .padding()
                
            }
            .padding(.bottom, keyboardHeight)
        }
        .onAppear() {
            movieVM.getComments(id: movie.id)
        }
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .background(colorScheme == .dark ? Color.backgroundColorDark : Color.backgroundColorLight)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MovieDescription: View {
    @Environment(\.colorScheme) var colorScheme
    let movie: Movie
    
    @EnvironmentObject var profileVM: ProfileViewModel
    
    @State var isExpanded: Bool = false
    @State var truncated: Bool = false
    var isInWishList: Bool {
        return profileVM.mainUser.favorite.contains(where: { eachMovie in
            eachMovie.id == movie.id
        })
    }
    
    @Binding var isShowingVideo: Bool
    @Binding var player: AVPlayer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(movie.title)
                .font(.custom("Dosis-Bold", size: 35))
                .fontWeight(.semibold)
            Text("1h 44m | Drama | 2002")
                .foregroundColor(.secondary)
                .font(.custom("Dosis-Regular", size: 16))
            
            BorderedButton(text: isInWishList ? "In Wishlist" : "Wishlist", systemImageName: "heart", color: colorScheme == .dark ? Color("AccentLight") : Color("AccentDark"), isOn: isInWishList, action: {
                if isInWishList {
                    profileVM.removeFilmFromFavourite(id: movie.id)
                } else {
                    profileVM.addFilmToFavourite(id: movie.id)
                }
            })
            
            Text(movie.descText)
                .font(.custom("Dosis-Regular", size: 24))
                .lineLimit(isExpanded ? nil : 5)
                .background(
                    Text(movie.descText).lineLimit(5)
                        .background(GeometryReader { displayedGeometry in
                            ZStack {
                                Text(movie.descText)
                                    .background(GeometryReader { fullGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                        }
                                    })
                            }
                            .frame(height: .greatestFiniteMagnitude)
                        })
                        .hidden()
                )
            
            if truncated {
                Button(action: { self.isExpanded.toggle() }) {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(.custom("Dosis-Bold", size: 16))
                }
            }
            
            HStack {
                Spacer()
                BorderedButton(text: "Watch", systemImageName: "play.fill", color: colorScheme == .dark ? .AccentColorLight : .AccentColorDark, isOn: false, width: 120, height: 50) {
                    let url = URL(string: movie.filmLink)!
                    VimeoVideoDecoder.fetchVideoURLFrom(url: url, completion: { (video: HCVimeoVideo?, error: Error?) -> Void in
                        if let err = error {
                            print("Error = \(err.localizedDescription)")
                            return
                        }
                        
                        guard video != nil else {
                            print("Invalid video object")
                            return
                        }
                        
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                        }
                        catch {
                            print("Setting category to AVAudioSessionCategoryPlayback failed.")
                        }
                        
                        self.player = AVPlayer(url: video?.videoURL[.quality1080p] ?? URL(string: "")!)
                        
                        self.isShowingVideo = true
                    })
                }
                Spacer()
            }
        }
        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
        .padding(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct CommentView: View {
    @State var isShowing = false
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var movieVM: MoviePageViewModel
    
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    isShowing = true
                }, label: {
                    WebImage(url: URL(string: comment.writer.avatar ?? ""))
                        .placeholder {
                            Image("avatar")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                })
                VStack(alignment: .leading) {
                    Text("\(comment.writer.username)")
                        .font(.custom("Dosis-Bold", size: 20))
                        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                    Text("\(comment.text)")
                        .font(.custom("Dosis-Regular", size: 16))
                        .foregroundColor(colorScheme == .dark ? .AccentColorLight : .AccentColorDark)
                }
                Spacer()
                if comment.writer.id == Session.shared.userId {
                    BorderedButton(text: "Delete", systemImageName: "trash.fill", color: .red, isOn: false) {
                        movieVM.deleteComment(id: comment.id)
                    }
                }
            }
            NavigationLink(destination: ProfilePage(user: comment.writer, isChangeable: false),
                           isActive: $isShowing, label: { EmptyView() })
        }
    }
}

struct AVPlayerView: UIViewControllerRepresentable {
    
    @Binding var avPlayer: AVPlayer?
    
    private var player: AVPlayer {
        return avPlayer!
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .pageSheet
        playerController.player = player
        playerController.player?.play()
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return LandscapeAVPlayerController()
    }
}

class LandscapeAVPlayerController: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
