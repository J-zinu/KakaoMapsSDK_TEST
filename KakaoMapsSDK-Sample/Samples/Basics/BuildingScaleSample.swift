//
//  BuildingScaleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/04/28.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class BuildingHeightSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        addButtonGui()
    }
    
    func addButtonGui() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let button = GuiButton("buildingScale")
        button.image = UIImage(named: "growingbuilding.png")
        
        let buttonGui = SpriteGui("button")
        buttonGui.addChild(button)
        buttonGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        buttonGui.delegate = self
        buttonGui.position = CGPoint(x: 0, y: 50)
        
        spriteLayer.addSpriteGui(buttonGui)
        buttonGui.show()
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        
        _scale = mapView.buildingScale + 0.1

        if _scale > 1.0 {
            _scale = 0.0
        }
        
        mapView.buildingScale = _scale
    }
    
    var _scale: Float = 0.0
}
