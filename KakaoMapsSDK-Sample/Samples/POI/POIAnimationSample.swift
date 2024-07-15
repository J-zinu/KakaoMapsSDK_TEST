//
//  POIAnimationSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// POI의 애니메이션 효과 예제.
class POIAnimationSample: APISampleBaseViewController, KakaoMapEventDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _index = 0
        super.init(coder: aDecoder)
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        let view = mapController?.getView("mapview") as! KakaoMap
        view.eventDelegate = self
        
        createLabelLayer()
        createPoiStyle()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let manager = view.getLabelManager()
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let icon = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle1 = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle1])
        
        manager.addPoiStyle(poiStyle1)
    }
    
    func createPoi(position: MapPoint, hide: Bool) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = 0
        
        let poi = layer?.addPoi(option:poiOption, at: position)
        poi!.show()
        
        // PoiAnimationEffect 지정
        let effect = DropAnimationEffect(pixelHeight: 250)
        effect.hideAtStop = hide
        effect.interpolation = AnimationInterpolation(duration: 1000, method: .cubicIn)
        effect.playCount = 1
        
        //실제 구현에서는 사용 후 removePoiAnimator/clearAllPoiAnimators를 해주어야 함.
        let animator = manager.addPoiAnimator(animatorID: "drop_animator_" + String(_index), effect: effect)
        animator?.addPoi(poi!)
        animator?.start()
        _index+=1
    }
    
    func terrainDidTapped(kakaoMap: KakaoMapsSDK.KakaoMap, position: KakaoMapsSDK.MapPoint) {
        createPoi(position: position, hide: false)
    }
    
    func terrainDidLongPressed(kakaoMap: KakaoMap, position: MapPoint) {
        createPoi(position: position, hide: false)
    }
    
    var _index: Int
}
