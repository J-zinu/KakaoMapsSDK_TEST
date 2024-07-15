//
//  POIStyleChangeSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// POI의 스타일을 교체하는 예제.
// 스타일은 미리 여러 개를 추가해 놓고 사용할 수 있다.
class POIStyleChangeSample: APISampleBaseViewController {
    
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
        
        let noti1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "noti.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti1])
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: iconStyle1, level: 0)
        let poiStyle1 = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle1])
        
        let noti2 = PoiBadge(badgeID: "badge2", image: UIImage(named: "noti2.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti2])
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: iconStyle2, level: 0)
        let poiStyle2 = PoiStyle(styleID: "customStyle2", styles: [perLevelStyle2])
        
        manager.addPoiStyle(poiStyle1)
        manager.addPoiStyle(poiStyle2)
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1", poiID: "poi1")
        poiOption.rank = 0
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
        poi1?.show()
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poi = layer?.getPoi(poiID: "poi1")
        poi?.changeStyle(styleID: "customStyle2")
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
}
