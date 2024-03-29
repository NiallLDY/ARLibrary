//
//  BookListView.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/30.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AudioToolbox

struct BookListView: View {
    @State var favouriteBooks: [Book]
    var body: some View {
        List(favouriteBooks) { book in
            BookRowView(selectbook: book)
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListView(favouriteBooks: testBookContent)
            BookRowView(selectbook: testBookContent[0])
        }
        
    }
}
struct BookRowView: View {
    @State var selectbook: Book
    @State var isFavourite = true
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                WebImage(url: URL(string: self.selectbook.image)!)
                    .placeholder(Image(systemName: "book"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 90)
                    .cornerRadius(5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(self.selectbook.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(self.selectbook.auther)
                        .lineLimit(1)
                    Text(self.selectbook.type)
                }
            }
            Spacer()
            Image(systemName: isFavourite ? "star.fill" : "star")
                .font(.system(size: 26))
                .foregroundColor(.yellow)
                .onTapGesture {
                    makeUnFavourite(id: self.selectbook.id, favourite: self.isFavourite ,completion: { success in
                        if (success) {
                            self.isFavourite.toggle()
                            let soundShort = SystemSoundID(1519)
                            AudioServicesPlaySystemSound(soundShort)
                        }
                    })
            }
        }
    }
}
