//
//  InfoWindowSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/04.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class InfoWindowSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("mapview OK")
        createInfoWindow()
    }
    
    func createInfoWindow() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let infoWindow = InfoWindow("infoWindow");

        // bodyImage
        let bodyImage = GuiImage("bgImage")
        bodyImage.image = UIImage(named: "white_black_round10.png")
        bodyImage.imageStretch = GuiEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)

        // tailImage
        let tailImage = GuiImage("tailImage")
        tailImage.image = UIImage(named: "white_black.png")
        
        //bodyImage의 child로 들어갈 layout.
        let layout: GuiLayout = GuiLayout("layout")
        layout.arrangement = .horizontal    //가로배치
        let button1: GuiButton = GuiButton("button1")
        button1.image = UIImage(named: "noti.png")!

        let text = GuiText("text")
        let style = TextStyle(fontSize: 20)
        text.addText(text: "안녕하세요~", style: style)
        //Text의 정렬. Layout의 크기는 child component들의 크기를 모두 합친 크기가 되는데, Layout상의 배치에 따라 공간의 여분이 있는 component는 align을 지정할 수 있다.
        text.align = GuiAlignment(vAlign: .middle, hAlign: .left)   // 좌중단 정렬.
        
        bodyImage.child = layout
        infoWindow.body = bodyImage
        infoWindow.tail = tailImage
        infoWindow.bodyOffset.y = -10

        layout.addChild(button1)
        layout.addChild(text)
        
        infoWindow.position = MapPoint(longitude: 126.978365, latitude: 37.566691)
        infoWindow.delegate = self

        let infoWindowLayer = view.getGuiManager().infoWindowLayer
        infoWindowLayer.addInfoWindow(infoWindow)
        infoWindow.show()
    }
    
    func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
        print("Gui: \(gui.name), Component: \(componentName) tapped")
        // GuiButton만 tap 이벤트가 발생할 수 있다.
        let guitext = gui.getChild("text") as? GuiText
        if let style = guitext?.textStyle(index: 0) {
            let newStyle = TextStyle(fontSize: style.fontSize, fontColor: UIColor.red, strokeThickness: style.strokeThickness, strokeColor: style.strokeColor)
            guitext?.updateText(index: 0, text: "Button pressed", style: newStyle)
            gui.updateGui() //Gui를 갱신한다
        }

    }
}
