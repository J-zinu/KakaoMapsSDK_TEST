//
//  SecondViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/07.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// RecoveryPoiSample 예제로부터 PoiOptions을 재활용한 배열을 전달받고, PoiOptions을 그대로 사용하여 Poi를 재생성한다.
class SecondViewController: APISampleBaseViewController {
    
    override func viewDidLoad() {
        
        positions = PoiDataSample.datas.map {
            MapPoint(longitude: $0.position.longitude, latitude: $0.position.latitude)
        }
        
        super.viewDidLoad()
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        // Style 생성
        createPoiStyles()
        // LabelLayer 생성.
        createLabelLayer()
        // LabelLayer 생성.
        createPois()
    }
    
    // Poi가 어떻게 표시될지를 지정하는 Style 생성.
    func createPoiStyles() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let icon1 = PoiIconStyle(symbol: UIImage(named: "pin_orange.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: icon1, level: 0)
        let poiStyle1 = PoiStyle(styleID: "orange", styles: [perLevelStyle1])
        labelManager.addPoiStyle(poiStyle1)
        
        let icon2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: icon2, level: 0)
        let poiStyle2 = PoiStyle(styleID: "red", styles: [perLevelStyle2])
        labelManager.addPoiStyle(poiStyle2)
        
        let icon3 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle3 = PerLevelPoiStyle(iconStyle: icon3, level: 0)
        let poiStyle3 = PoiStyle(styleID: "green", styles: [perLevelStyle3])
        labelManager.addPoiStyle(poiStyle3)
        
        let icon4 = PoiIconStyle(symbol: UIImage(named: "pin_blue.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle4 = PerLevelPoiStyle(iconStyle: icon4, level: 0)
        let poiStyle4 = PoiStyle(styleID: "blue", styles: [perLevelStyle4])
        labelManager.addPoiStyle(poiStyle4)
    }
    
    // LabelLayer 생성.
    func createLabelLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let layer = LabelLayerOptions(layerID: "layer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    // PoiOptions을 이전에 썼던것을 재활용해서 지도에 표시한다.
    func createPois() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let layer = labelManager.getLabelLayer(layerID: "layer")
        // 여기서는 옵션을 새로 생성하지 않고, 프로퍼티를 통해 전달받은 Options을 그대로 재활용해서 Poi를 재생성한다.
        if let items = layer?.addPois(options: options, at: positions) {
            for item in items {
                
                // 생성해둔 Poi 객체들은 따로 저장해두고, 엔진에서 지워지기 전이나 사용자가 지우기 전까지는 자유롭게 사용할 수 있다.
                pois[item.itemID] = item
            }
        }
        
        mapView.moveCamera(CameraUpdate.make(area: AreaRect(points: positions)))
        layer?.showPois(poiIDs: pois.map{ $0.key })
    }
    
    // 현재 view가 사라질 때
    override func viewDidDisappear(_ animated: Bool) {
        // 엔진이 stop되면 추가했던 Poi는 모두 지워진다.
        mapController?.resetEngine()
        // Poi가 모두 지워졌으므로, 별도로 사용자가 들고있던 Poi Table도 모두 삭제한다.
        pois.removeAll()
    }
    
    var positions = [MapPoint]()
    var options = [PoiOptions]()
    var pois = [String: Poi]()
}
