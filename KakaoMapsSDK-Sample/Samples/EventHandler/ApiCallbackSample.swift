//
//  ApiCallbackSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/11/06.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// API에 추가할 수 있는 콜백 이벤트 관련 예제
// 지도 위에 얹을 수 있는 Label, Shape, Route의 add 혹은 remove 동작에 대해 완료 콜백을 받을 수 있다.
// 또한 카메라 이동과 관련된 모든 동작에 대해서도 완료 콜백을 지정하면 카메라 이동이 끝났을 때 콜백을 받을 수 있다.
// 해당 예제에서는 특정 버튼을 누르면 여러개의 Poi가 추가되고, Poi추가 완료 -> 카메라 이동 완료 -> Poi show 순서로 콜백을 수행한다.
class ApiCallbackSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    func createPois() {
        // Poi가 속할 레이어 생성
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        let labelManager = mapView?.getLabelManager()
        let layer = labelManager?.addLabelLayer(option: LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 0))
        
        // Poi가 그려질 스타일 생성
        let iconStyle = PoiIconStyle(symbol: UIImage(named: "mapIcoBookmark_01.png")!, anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "PoiStyle1", styles: [perLevelStyle])
        labelManager?.addPoiStyle(poiStyle)
        
        // Pois 생성
        let coord = MapPoint(longitude: 126.875658, latitude: 37.492889)
        let boundary = GeoCoordinate(longitude: 0.026949, latitude: 0.035932)
        let options = PoiOptions(styleID: "PoiStyle1")
        
        var positions = [MapPoint]()
        for _ in 1 ... 100 {
            let rand = GeoCoordinate(
                longitude: Double.random(in: 0...boundary.longitude),
                latitude: Double.random(in: 0...boundary.latitude))
            
            positions.append(MapPoint(longitude: coord.wgsCoord.longitude + rand.longitude,
                                      latitude: coord.wgsCoord.latitude + rand.latitude))
        }
        
        // Pois 추가 -> 카메라 애니메이션 -> show Pois
        let _  = layer?.addPois(option: options, at: positions) { [weak mapView, weak layer](pois: [Poi]?) -> Void in //addPois 완료 콜백 추가
            guard let view = mapView else { return }
            
            if let items = pois {
                let rect = AreaRect(points: items.map{ $0.position }) // 추가된 poi를 기반으로 areaRect를 생성하여 카메라를 이동시킨다.
                view.animateCamera( cameraUpdate: CameraUpdate.make(area: rect), options: CameraAnimationOptions(autoElevation: false, consecutive: false, durationInMillis: 2000)) { () -> Void in
                    guard let labelLayer = layer else { return }
                    labelLayer.showAllPois()    // 카메라 이동이 완료되면 layer에 추가된 모든 poi를 표시한다.
                }
            }
        }
    }
    
    
    @IBAction func addPois(_ sender: Any) {
        createPois()
    }
}
