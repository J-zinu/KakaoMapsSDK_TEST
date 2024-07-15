//
//  SecondViewHostingController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/05/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct ContentView: View {
    @State var draw: Bool = false   //뷰의 appear 상태를 전달하기 위한 변수.
    var body: some View {
        KakaoMapView(draw: $draw).onAppear(perform: {
                self.draw = true
            }).onDisappear(perform: {
                self.draw = false
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

class SecondViewHostingController: UIHostingController<ContentView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ContentView())
    }
}

struct SecondViewHostingController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(draw: false)
    }
}
