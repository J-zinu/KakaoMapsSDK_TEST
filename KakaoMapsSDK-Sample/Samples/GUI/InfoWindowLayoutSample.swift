//
//  InfoWindowLayoutSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/06/18.
//  Copyright © 2021 kakao. All rights reserved.
//

// 여러줄의 Layout으로 구성된 InfoWindow를 만드는 에제.

import Foundation
import KakaoMapsSDK

class InfoWindowLayoutSample: APISampleBaseViewController, KakaoMapEventDelegate, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.eventDelegate = self
        
        createInfoWindow()
    }
    
    // Layout 구성:
    // InfoWindow
    //   ㄴ GuiImage(body)
    //      ㄴ GuiLayout(vertical)
    //          ㄴ GuiLayout(horizontal)
    //              ㄴ button1
    //              ㄴ button2
    //              ㄴ button3
    //          ㄴ GuiLayout(horizontal)
    //              ㄴ button4
    //              ㄴ button5
    func createInfoWindow() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let viewRect = mapView.viewRect
        let infoWindowLayer = mapView.getGuiManager().infoWindowLayer
        
        // infoWindow. 현재 화면 중앙에 표시
        let infoWindow = InfoWindow("InfoWindow")
        infoWindow.position = mapView.getPosition(CGPoint(x: viewRect.width/2, y: viewRect.height/2))
        
        // body생성
        let body = GuiImage("body")
        body.image = UIImage(named: "white_black_round10.png")
        body.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        body.align = GuiAlignment(vAlign: .top, hAlign: .left)
        body.imageStretch = GuiEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)

        // infoWindow body 지정
        infoWindow.body = body
        
        // body의 child로 vertical layout 추가. vertical layout에 addChild를 할 경우, 컴포넌트가 수직방으로 쌓인다.
        let vLayout = GuiLayout("vLayout")
        vLayout.arrangement = .vertical
        infoWindow.body?.child = vLayout
        
        // 추가한 vLayout에 들어갈 2개의 horizontal layout을 생성
        // 이 두개의 horizontal layout에 버튼을 child로 추가하면 수평방향으로 들어간다.
        let topLayout = GuiLayout("topLayout")
        topLayout.arrangement = .horizontal
        let bottomLayout = GuiLayout("bottomLayout")
        bottomLayout.arrangement = .horizontal
        
        // vLayout에 생성한 2개의 레이아웃을 추가한다.
        vLayout.addChild(topLayout)
        vLayout.addChild(bottomLayout)
        
        // 버튼을 생성해서 각 horizontal layout에 추가한다.
        
        // topLayout에 들어갈 버튼
        let btn1 = GuiButton("bike")
        btn1.image = UIImage(named: "mapBtnBikeNormal@2x.png")
        btn1.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn2 = GuiButton("bus")
        btn2.image = UIImage(named: "mapBtnBusNormal@2x.png")
        btn2.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn3 = GuiButton("Cadastral")
        btn3.image = UIImage(named: "mapBtnCadastralNormal@2x.png")
        btn3.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        
        topLayout.addChild(btn1)
        topLayout.addChild(btn2)
        topLayout.addChild(btn3)
        
        // bottomLayout에 들어갈 버튼
        let btn4 = GuiButton("landform")
        btn4.image = UIImage(named: "mapBtnLandformNormal@2x.png")
        btn4.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        let btn5 = GuiButton("cctv")
        btn5.image = UIImage(named: "mapBtnCctvNormal@2x.png")
        btn5.align = GuiAlignment(vAlign: .bottom, hAlign: .center)
        
        bottomLayout.addChild(btn4)
        bottomLayout.addChild(btn5)
        
        // 현재까지 추가한 컴포넌트로 구성된 인포윈도우를 추가하고, 화면에 표시한다.
        infoWindowLayer.addInfoWindow(infoWindow)
        infoWindow.show()
        
        infoWindow.delegate = self
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        print("gui \(gui.name) tapped. component: \(componentName)")
    }
}
