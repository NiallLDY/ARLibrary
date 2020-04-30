//
//  BookListView.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/30.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

import SwiftUI

struct BookListView: View {
    @State var selectbook: Book = testBookContent[0]
    var body: some View {
        Text(selectbook.name)
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
