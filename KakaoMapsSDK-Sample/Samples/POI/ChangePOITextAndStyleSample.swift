//
//  ChangePOITextAndStyleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// POI의 스타일과 Text를 함께 교체하는 예제.
// changeStyle과 다르게, changeTextAndStyle은 style과 Poi에 추가된 텍스트를 함께 바꿀 때 사용한다.
class ChangePOITextAndStyleSample: APISampleBaseViewController {

    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createLabelLayer()
        createPoiStyle()
        createPois()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let badge1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "noti.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [badge1])
        let text1 = PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.green))
        let textStyle1 = PoiTextStyle(textLineStyles: [text1])
        textStyle1.textLayouts = [PoiTextLayout.center]
        let poiStyle1 = PoiStyle(styleID: "customStyle1", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle1, textStyle: textStyle1, level: 0)
        ])
        
        let badge2 = PoiBadge(badgeID: "badge2", image: UIImage(named: "noti2.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [badge2])
        let text2 = PoiTextLineStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red))
        let textStyle2 = PoiTextStyle(textLineStyles: [text2])
        textStyle2.textLayouts = [PoiTextLayout.center]
        let poiStyle2 = PoiStyle(styleID: "customStyle2", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle2, textStyle: textStyle2, level: 0)
        ])
        
        manager.addPoiStyle(poiStyle1)
        manager.addPoiStyle(poiStyle2)
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1", poiID: "poi1")
        poiOption.rank = 0
        poiOption.addText(PoiText(text: "POI Text", styleIndex: 0))
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
        poi1?.show()
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poi = layer?.getPoi(poiID: "poi1")
        
        // 바꾸고자 하는 PoiText로 업데이트한다.
        // 이때 PoiText가 사용하는 styleIndex는 바꿀 스타일에 매치된다.
        poi?.changeTextAndStyle(texts: [PoiText(text: "Changed POI Text", styleIndex: 0)], styleID: "customStyle2")
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
}
