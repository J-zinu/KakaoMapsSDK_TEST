//
//  OverlayMapSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/03/16.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

/// API에서 제공하는 overlay 변경 예제
///
/// viewInfo 및 overlay에 대한 사용권한이 있다고 가정하므로, 권한이 없을 경우 안보일 수 있다. 권한 관련 내용은 문서를 참조.
class OverlayMapSample: APISampleBaseViewController, GuiEventDelegate {

    required init?(coder aDecoder: NSCoder) {
        _baseMapStatus = [String: Bool]()
        _baseMapStatus["map"] = true
        _baseMapStatus["skyview"] = false
        
        _overlayStatus = [String: Bool]()
        _overlayStatus["roadview_line"] = false
        _overlayStatus["hill_shading"] = false
        _overlayStatus["bicycle_road"] = false
        
        super.init(coder: aDecoder)
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.eventDelegate = self
        
        addViewInfoButtonGui()
        addOverlayButtonGui()
    }
    
    /// roadview_line, hill_shading, bicycle_road 등 overlay 변경을 위한 button gui 생성
    func addOverlayButtonGui() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let roadviewLine = GuiButton("roadview_line")
        roadviewLine.image = UIImage(named: "roadview_on.png")
        
        let hillShading = GuiButton("hill_shading")
        hillShading.image = UIImage(named: "hillShading.png")
        
        let bicycleRoad = GuiButton("bicycle_road")
        bicycleRoad.image = UIImage(named: "route.png")
        
        let buttonGui = SpriteGui("overlay")
        buttonGui.addChild(roadviewLine)
        buttonGui.addChild(hillShading)
        buttonGui.addChild(bicycleRoad)
        
        buttonGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        buttonGui.delegate = self
        buttonGui.arrangement = .horizontal
        buttonGui.position = CGPoint(x: 0, y: 50)
        
        spriteLayer.addSpriteGui(buttonGui)
        buttonGui.show()
    }
    
    /// view Info 변경을 위한 button array gui 생성
    func addViewInfoButtonGui() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let normalMap = GuiButton("map")
        normalMap.image = UIImage(named: "ndm_1.png")
        
        let skyview = GuiButton("skyview")
        skyview.image = UIImage(named: "skyview_1.png")
        
        let buttonGui = SpriteGui("baseMap")
        
        buttonGui.addChild(normalMap)
        buttonGui.addChild(skyview)
        
        buttonGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .center)
        buttonGui.delegate = self
        buttonGui.arrangement = .horizontal
        buttonGui.position = CGPoint(x: 0, y: 130)
        
        spriteLayer.addSpriteGui(buttonGui)
        buttonGui.show()
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        
        /// viewInfo 변경
        if gui.name == "baseMap" {
            if let status = _baseMapStatus[componentName], status == false {
                mapView.changeViewInfo(appName: "openmap", viewInfoName: componentName)
                
                /// skyview인경우 hybrid overlay를  켜준다.
                if componentName == "skyview" {
                    mapView.showOverlay("hybrid")
                }
                else {
                    mapView.hideOverlay("hybrid")
                }
                
                /// 기존 base map의 status를 변경
                _baseMapStatus[_viewInfo] = !_baseMapStatus[_viewInfo]!
                /// 새 base map status를 변경
                _baseMapStatus[componentName] = !status
                _viewInfo = componentName
            }
        }

        /// 버튼 클릭에 따라 overlay on/off를 제어한다.
        if gui.name == "overlay" {
            if let status = _overlayStatus[componentName] {
            
                /// 그 외 overlay 제어
                if status == false {
                    mapView.showOverlay(componentName)
                }
                else {
                    mapView.hideOverlay(componentName)
                }
                
                
                /// on/off status
                _overlayStatus[componentName] = !status
            }
        }
    }
    
    var _viewInfo: String = "map"
    var _baseMapStatus: [String: Bool]
    var _overlayStatus: [String: Bool]
}

// KakaoMap.changeViewInfoName의 성공 및 실패 여부를 콜백으로 전달받을 수 있다.
extension OverlayMapSample: KakaoMapEventDelegate {
    // changeViewInfoName 성공시 호출
    func onViewInfoChanged(kakaoMap: KakaoMap, viewInfoName: String) {
        print("\(kakaoMap.viewName()) success to change viewInfo \(viewInfoName)")
    }
    
    // changeViewInfoName 실패 호출
    func onViewInfoChangeFailure(kakaoMap: KakaoMap, viewInfoName: String) {
 
    }
}
