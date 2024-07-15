//
//  SpriteGUISample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/04.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class SpriteGUISample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("mapview OK")
        createSpriteGUI()
    }
    
    func createSpriteGUI() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let spriteLayer = mapView.getGuiManager().spriteGuiLayer
        let spriteGui = SpriteGui("testSprite") //SpriteGui를 만듬. SpriteGui는 화면좌표상의 특정지점에 고정되는 GUI이다. 구성방법은 InfoWindow와 동일하다.
        
        spriteGui.arrangement = .horizontal
        spriteGui.bgColor = UIColor.clear
        spriteGui.splitLineColor = UIColor.white
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right) //화면의 우하단으로 배치
        
        let button1 = GuiButton("button1")
        button1.image = UIImage(named: "track_location_btn.png")
        
        let button2 = GuiButton("button2")
        button2.image = UIImage(named: "tile.png")
        
        spriteGui.addChild(button1)
        spriteGui.addChild(button2)
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.delegate = self
        spriteGui.show()
    }
    
    func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
        print("Gui: \(gui.name), Component: \(componentName) tapped")
        if componentName == "button1" {
            //do something
        }
        
        if componentName == "button2" {
            //do something
        }
    }    
}
