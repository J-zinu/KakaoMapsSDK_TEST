//
//  InfoWindowAnimationSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/09.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class InfoWindowAnimationSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("mapview OK")
        createInfoWindow()
        createInfoWindowAnimator()
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
        layout.arrangement = .vertical    //세로배치
        
        let buttonLayout: GuiLayout = GuiLayout("buttonLayout")
        buttonLayout.arrangement = .horizontal
        buttonLayout.align = GuiAlignment(vAlign: .middle, hAlign: .center)
        let button1: GuiButton = GuiButton("dropAnimation")
        button1.image = UIImage(named: "noti.png")!
        button1.padding = GuiPadding(left: 10, right: 10, top: 10, bottom: 10)
        let button2: GuiButton = GuiButton("moveAnimation")
        button2.image = UIImage(named: "noti2.png")!
        button2.padding = GuiPadding(left: 10, right: 10, top: 10, bottom: 10)
        buttonLayout.addChild(button1)
        buttonLayout.addChild(button2)

        let text = GuiText("text")
        let style = TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red)
        let text2 = GuiText("text2")
        let style2 = TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.blue)
    
        text.addText(text: "빨간색: DropAnimation", style: style)
        text2.addText(text: "파란색: Move InfoWindow", style: style2)
        //Text의 정렬. Layout의 크기는 child component들의 크기를 모두 합친 크기가 되는데, Layout상의 배치에 따라 공간의 여분이 있는 component는 align을 지정할 수 있다.
        text.align = GuiAlignment(vAlign: .middle, hAlign: .left)   // 좌중단 정렬.
        
        bodyImage.child = layout
        infoWindow.body = bodyImage
        infoWindow.tail = tailImage
        infoWindow.bodyOffset.y = -10

        layout.addChild(buttonLayout)
        layout.addChild(text)
        layout.addChild(text2)
        
        infoWindow.position = MapPoint(longitude: 126.978365, latitude: 37.566691)
        infoWindow.delegate = self

        let infoWindowLayer = view.getGuiManager().infoWindowLayer
        infoWindowLayer.addInfoWindow(infoWindow)
        infoWindow.show()
    }
    
    //InfoWindow에 DropAnimation효과를 주기 위해 Animator를 생성한다.
    func createInfoWindowAnimator() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getGuiManager()
        
        // InfoWindow Animation Effect 지정
        let effect = DropAnimationEffect(pixelHeight: 250)
        effect.hideAtStop = false
        effect.interpolation = AnimationInterpolation(duration: 1000, method: .cubicIn)
        effect.playCount = 1
        
        // InfoWindow Animator 생성
        let _ = manager.addInfoWindowAnimator(animatorID: "drop_animator", effect: effect)
    }
    
    func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
        print("Gui: \(gui.name), Component: \(componentName) tapped")
        // GuiButton만 tap 이벤트가 발생할 수 있다.

        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getGuiManager()
         
        if componentName == "dropAnimation" {
            
            // 생성한 InfoWindowAnimator를 가져온다
            let animator = manager.getInfoWindowAnimator(animatorID: "drop_animator")
            animator?.addInfoWindow(gui as! InfoWindow) // animator에 InfoWindow를 추가한다.
            
            animator?.start() // animator 시작. animator에 들어가있는 InfoWindow에 애니메이션 효과가 적용된다.
        }
        else if componentName == "moveAnimation" {

            // InfoWindow의 moveAt 함수 호출. 해당 지점까지 duration기간동안 이동한다.
            (gui as! InfoWindow).moveAt(MapPoint(longitude: 127.022316, latitude: 37.496339), duration: 10000)

        }

    }
}
