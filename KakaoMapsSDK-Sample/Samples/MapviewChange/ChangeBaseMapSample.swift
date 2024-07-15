//
//  ChangeBaseMapSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/03/16.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

/// API에서 제공하는 base map 변경 예제
///
/// 총 세가지 종류의 base map을 제공한다.  각 base map으로 변경은 KakaoMap 객체의 viewInfoName을 통해 변경할 수 있다.
///
/// - kakao_map : 일반 2d 지도
///
/// - skyview: 스카이뷰
///
/// - cadastral_map : 지적편집도
class ChangeBaseMapSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        let mapView = mapController?.getView(viewName) as! KakaoMap
        mapView.eventDelegate = self
        addButtonGui()
    }
    
    // skyview, cadastral map 변경을 위한 button array gui 생성
    func addButtonGui() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let normalMap = GuiButton("map")
        normalMap.image = UIImage(named: "ndm_1.png")
        
        let skyview = GuiButton("skyview")
        skyview.image = UIImage(named: "skyview_1.png")
        
        let cadastral = GuiButton("cadastral_map")
        cadastral.image = UIImage(named: "tile.png")
        
        let buttonGui = SpriteGui("buttons")
        buttonGui.addChild(normalMap)
        buttonGui.addChild(skyview)
        buttonGui.addChild(cadastral)
        
        buttonGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        buttonGui.delegate = self
        buttonGui.arrangement = .horizontal
        buttonGui.position = CGPoint(x: 0, y: 50)
        
        spriteLayer.addSpriteGui(buttonGui)
        buttonGui.show()
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        
        mapView.changeViewInfo(appName: "openmap", viewInfoName: componentName)
        if componentName == "skyview" {
            /// skyview의 경우, hybrid overlay on/off가 가능하다.
//            mapView.showOverlay("hybrid")
        }
        else {
            mapView.hideOverlay("hybrid")
        }
    }
}


// KakaoMap.changeViewInfoName의 성공 및 실패 여부를 콜백으로 전달받을 수 있다.
extension ChangeBaseMapSample: KakaoMapEventDelegate {
    // changeViewInfoName 성공시 호출
    func onViewInfoChanged(kakaoMap: KakaoMap, viewInfoName: String) {
        print("\(kakaoMap.viewName()) success to change viewInfo \(viewInfoName)")
    }
    // changeViewInfoName 실패 호출
    func onViewInfoChangeFailure(kakaoMap: KakaoMap, viewInfoName: String) {
        print("\(kakaoMap.viewName()) fail to change viewInfo \(viewInfoName)")
    }
}
