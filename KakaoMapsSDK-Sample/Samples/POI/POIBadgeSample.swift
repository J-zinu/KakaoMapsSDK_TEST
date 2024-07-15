//
//  POIBadgeSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// POI에 Badge를 사용하는 예제.
// POI에 스타일에서 지정된 심볼외에 추가적인 정보를 표현하기 위해, badge를 추가하여 심볼이나 텍스트를 추가로 그리도록 할 수 있다.
class POIBadgeSample: APISampleBaseViewController {
    
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
        let iconStyle = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = 0
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
        // PoiBadge를 생성하여 POI에 추가한다.
        let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "noti.png")!, offset: CGPoint(x: 0.1, y: 0.1), zOrder: 1)
        poi1?.addBadge(badge)
        poi1?.show()
        poi1?.showBadge(badgeID: "noti")
    }   
}
