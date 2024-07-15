//
//  MarginTestSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/01/27.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// KakaoMap의 margin을 설정하는 예제.
//
// Margin은 지도 위에 다른 뷰나 Gui객체가 일부분을 가릴 때, 지도를 리사이즈 하지 않고 지도 조작이 자연스럽게 한다.
//
// margin을 설정하면 제스처에 의한 움직임, 카메라 이동, Gui배치등 기준이 되는 기준점이 변한다.
//
// CurrentPositioMarker를 화면 중앙에 생성하여 tracking하도록 설정해서 설정한 margin의 중심을 확인한다.
//
// 스크린 화면을 4사분면으로 나누고, 버튼을 누를때마다 마진값이 변하고 cpm과 gui로 해당 화면 기준점을 확인한다.
class MarginTestSample: APISampleBaseViewController, GuiEventDelegate {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("mapview OK")
        
        createLabelLayer()
        createPoiStyle()
        createPois()
        
        showCompass()
        createButtonSprite()
    }
    
    // CPM 생성을 위한 LabelLayer 생성
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let positionLayerOption = LabelLayerOptions(layerID: "PositionPoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager.addLabelLayer(option: positionLayerOption)
    }
    
    // CPM 마커 스타일 생성
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let marker = PoiIconStyle(symbol: UIImage(named: "map_ico_marker.png"))
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: marker, level: 0)
        let poiStyle1 = PoiStyle(styleID: "positionPoiStyle", styles: [perLevelStyle1])
        manager.addPoiStyle(poiStyle1)
    }
    
    // CPM Poi 생성. 화면 중심에 생성하고, tracking해서 화면 중심에 고정되도록 한다.
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let trackingManager = view.getTrackingManager()
        let positionLayer = manager.getLabelLayer(layerID: "PositionPoiLayer")
        
        // 현위치마커의 몸통에 해당하는 POI
        let poiOption = PoiOptions(styleID: "positionPoiStyle", poiID: "PositionPOI")
        poiOption.rank = 1
        poiOption.transformType = .decal    //화면이 기울여졌을 때, 지도를 따라 기울어져서 그려지도록 한다.
        
        let center = view.getPosition(CGPoint(x: view.viewRect.size.width * 0.5, y: view.viewRect.size.height * 0.5))

        if let cpm = positionLayer?.addPoi(option:poiOption, at: center) {
            cpm.show()
            
            trackingManager.startTrackingPoi(cpm)
        }
    }
    
    // 나침반 표시. 표시 영역의 left/top에 표시한다.
    func showCompass() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        
        mapView.setCompassPosition(origin: GuiAlignment(vAlign: .top, hAlign: .left), position: CGPoint(x: 0, y: 0))
        mapView.showCompass()
    }
    
    // 버튼 SpriteGui 생성. 기준 화면의 bottom/right에 생성한다.
    //
    // 해당 버튼을 탭할때마다 margin을 재설정한다.
    func createButtonSprite() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let button = GuiButton("button")
        button.image = UIImage(named: "track_location_btn.png")
        
        let spriteGui = SpriteGui("buttonGui")
        spriteGui.addChild(button)
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right)
        spriteGui.delegate = self
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.show()
    }
    
    // gui button을 클릭할때마다 호출. 클릭에 따라 화면의 마진 비율을 다르게 설정한다.
    func setMargins(_ clickState: Int) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        
        let width = mapView.viewRect.size.width
        let height = mapView.viewRect.size.height
        
        switch clickState {
        case 0:
            mapView.setMargins(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        case 1:
            mapView.setMargins(UIEdgeInsets(top: 0, left: 0, bottom: height/2, right: width/2))
        case 2:
            mapView.setMargins(UIEdgeInsets(top: 0, left: width/2, bottom: height/2, right: 0))
        case 3:
            mapView.setMargins(UIEdgeInsets(top: height/2, left: 0, bottom: 0, right: width/2))
        case 4:
            mapView.setMargins(UIEdgeInsets(top: height/2, left: width/2, bottom: 0, right: 0))
        default:
            mapView.setMargins(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    func guiDidTapped(_ gui: GuiBase, componentName: String) {
        _clickState = (_clickState + 1) % 5
        setMargins(_clickState)
    }
    
    var _clickState: Int = 0
}
