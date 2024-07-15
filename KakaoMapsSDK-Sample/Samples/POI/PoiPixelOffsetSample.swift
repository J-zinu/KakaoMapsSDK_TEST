//
//  PoiPixelOffsetSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/01/28.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// Poi pixelOffset property를 이용하여 복잡한 구성의 poi를 생성하는 예제.
//
// 같은 position을 가진 Poi여도 pixelOffset을 적절하게 이용하여 다양한 구성의 Poi를 만들 수 있다.
//
// Poi의 Badge의 경우, 클릭이 불가능하므로 Poi 심볼 외에 클릭이 가능한 뱃지유형을 넣고자 하는 경우 해당 기능을 활용할 수 있다.
//
// pixelOffset은 position을 기준으로 left/top 방향은 (-), right/bottom방향은 (+)로 조절한다.
//
// 해당 예제에서는 마커 하나 + 버튼처럼 동작하는 Poi 3개를 생성하여, 버튼을 클릭하면 버튼 중앙에 마커를 하나 새로 띄운다.
class PoiPixelOffsetSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createLabelLayer()
        createMarkerStyle()
        createButtonStyle()
        createMarkerPoi()
        createButtonPois()
    }
    
    // Poi 생성을 위해 LabelLayer를 생성한다.
    func createLabelLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        // LabelLayer 생성
        let option = LabelLayerOptions(layerID: "labelLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        _labelLayer = labelManager.addLabelLayer(option: option)
    }
    
    // Marker의 Style을 생성한다.
    func createMarkerStyle() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        // 기본 마커 스타일 생성.
        let iconStyle = PoiIconStyle(symbol: _markerSymbol, anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale), badges: nil)
        let markerStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        labelManager.addPoiStyle(PoiStyle(styleID: "markerStyle", styles: [markerStyle]))
        
        // 버튼을 클릭했을 때 띄울 작은 마커 스타일 생성.
        let smallIconStyle = PoiIconStyle(symbol: _smallMarkerSymbol, anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale), badges: nil)
        let smallMarkerStyle = PerLevelPoiStyle(iconStyle: smallIconStyle, level: 0)
        labelManager.addPoiStyle(PoiStyle(styleID: "smallMarkerStyle", styles: [smallMarkerStyle]))
    }
    
    // Button의 On/Off Style을 생성한다.
    func createButtonStyle() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        // button Poi를 클릭했을 때 보여질 스타일
        let onIcon = PoiIconStyle(symbol: _onButtonSymbol, anchorPoint: CGPoint(x: 0.5, y: 0.5), transition: PoiTransition(entrance: .scale, exit: .scale), badges: nil)
        let onStyle = PerLevelPoiStyle(iconStyle: onIcon, level: 0)
        labelManager.addPoiStyle(PoiStyle(styleID: "onButtonStyle", styles: [onStyle]))
        
        let offIcon = PoiIconStyle(symbol: _buttonSymbol, anchorPoint: CGPoint(x: 0.5, y: 0.5), transition: PoiTransition(entrance: .scale, exit: .scale), badges: nil)
        let offStyle = PerLevelPoiStyle(iconStyle: offIcon, level: 0)
        labelManager.addPoiStyle(PoiStyle(styleID: "offButtonStyle", styles: [offStyle]))
    }
    
    // Marker Poi를 생성한다.
    func createMarkerPoi() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let center = mapView.getPosition(CGPoint(x: mapView.viewRect.size.width/2, y: mapView.viewRect.size.height/2))
        
        // MakerPoi 생성
        let poiOption = PoiOptions(styleID: "markerStyle", poiID: "marker")
        let marker = _labelLayer?.addPoi(option: poiOption, at: center)
        marker?.show()
        
        // 버튼Poi를 클릭하면 띄울 작은 marker 생성
        let poiOption2 = PoiOptions(styleID: "smallMarkerStyle", poiID: "smallMarker")
        poiOption2.rank = 1
        _smallMarker = _labelLayer?.addPoi(option: poiOption2, at: center)
    }
    
    // 똑같은 스타일로 3개의 버튼 Poi를 생성한다.
    func createButtonPois() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let center = mapView.getPosition(CGPoint(x: mapView.viewRect.size.width/2, y: mapView.viewRect.size.height/2))
        
        var buttonPois = [Poi]()
        
        // buttonPoi 생성. 똑같은 스타일로 3개를 생성한다.
        for index in 0 ..< 3 {
            let buttonPoiOptions = PoiOptions(styleID: "offButtonStyle", poiID: "button" + String(index+1))
            buttonPoiOptions.clickable = true
            
            
            if let poi = _labelLayer?.addPoi(option: buttonPoiOptions, at: center) {
                // Poi를 생성하고, 각 ButtonPoi에 클릭 이벤트 핸들러를 추가한다.
                let _ = poi.addPoiTappedEventHandler(target: self, handler: PoiPixelOffsetSample.clickedButtonPoi)
                buttonPois.append(poi)
            }
        }
        
        // buttonPoi에 pixelOffset을 적용한다. 기본으로 생성한 마커 위에 3개의 버튼 array처럼 배치한다.
        // 마커의 Anchor는 (0.5, 1.0), 즉 심볼을 기준으로 맨 아래쪽이 중심이므로 마커의 심볼 height값만큼 offset을 준다.
        // 버튼의 Anchor는 (0.5, 0.5)이므로 버튼 심볼의 height * 0.5만큼 올린다.
        // 즉, pixelOffset.y = -( markerSymbol.height + buttonSymbol.height * 0.5 )
        // pixelOffset.x는 버튼의 width값을 이용하여 적절히 조절하여 array처럼 배치
        
        let yOffset = -((_markerSymbol?.size.height)! + (_buttonSymbol?.size.height)! * 0.5)
        
        let buttonWidth = Double((_buttonSymbol?.size.width)!)
        let totalWidth = Double((_buttonSymbol?.size.width)! * 3.0)
    
        var startOffset = -totalWidth * 0.5
        for index in 0 ..< 3 {
            let offset = CGPoint(x: Double(startOffset + buttonWidth * 0.5),
                                 y: Double(yOffset))
            startOffset += Double(buttonWidth)
            
            buttonPois[index].pixelOffset = offset
            buttonPois[index].show()
        }
    }
    
    func clickedButtonPoi(_ param: PoiInteractionEventParam) {
        if _clickedId != param.poiItem.itemID {
            
            // 기존 clickedId를 가진 ButtonPoi를 off Button Style로 바꾸고, 띄운 작은 마커를 숨긴다.
            if let buttonPoi = _labelLayer?.getPoi(poiID: _clickedId) {
                buttonPoi.changeStyle(styleID: "offButtonStyle")
                _smallMarker?.hide()
            }
            
            // 새로 클릭된 Poi를 클릭 스타일로 바꾸고, 작은 마커를 클릭된 buttonPoi의 픽셀오프셋만큼 새로 업데이트한다.
            if let buttonPoi = _labelLayer?.getPoi(poiID: param.poiItem.itemID) {
                buttonPoi.changeStyle(styleID: "onButtonStyle")
                _smallMarker?.pixelOffset = buttonPoi.pixelOffset
                _smallMarker?.show()
            }
            
            _clickedId = param.poiItem.itemID
        }
    }
    
    var _labelLayer: LabelLayer?
    let _markerSymbol = UIImage(named: "search_ico_pin_map.png")
    let _smallMarkerSymbol = UIImage(named: "search_ico_pin_small_map")
    let _buttonSymbol = UIImage(named: "track_location_btn.png")
    let _onButtonSymbol = UIImage(named: "track_location_btn_pressed.png")
    var _clickedId = ""
    var _smallMarker: Poi?
}
