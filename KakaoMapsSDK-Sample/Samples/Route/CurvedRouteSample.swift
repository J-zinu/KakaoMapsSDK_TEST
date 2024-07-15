//
//  CurvedRouteSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/07/07.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// API 1.x에서 제공하던 PolylineType -> LeftCurve, RightCurve가 2.0에서는 빠짐.
// RouteSegment는 lineType없이 MapPoint로만 구성할 수 있다.
// 해당 예제에서는 기존의 LeftCurve, RightCurve를 대체할 수 있도록 두 점과 곡선 생성 유틸을 이용하여 곡선형 Route를 생성한다.
class CurvedRouteSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createRouteStyleSet()
        createRouteline()
    }
    
    // RouteStyleSet 생성
    func createRouteStyleSet() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
  
        let routeStyle = RouteStyle(styles: [
            PerLevelRouteStyle(width: 18, color: UIColor.blue, level: 0),
            PerLevelRouteStyle(width: 18, color: UIColor.green, level: 15)
        ])
        
        let styleSet = RouteStyleSet(styleID: "routeStyleSet", styles: [routeStyle])
        
        manager?.addRouteStyleSet(styleSet)
    }
    
    // Route생성
    func createRouteline() {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        let manager = mapView?.getRouteManager()
        let layer = manager?.addRouteLayer(layerID: "RouteLayer", zOrder: 0)
        
        // 서울에서 부산까지 두 점을 이용하여 RightCurve를 생성한다.
        // Right / Left는 시작점에서 끝점으로 가는 방향을 기준으로 false일경우 RightCurve, true일경우 LeftCurve 형태의 MapPoint 배열을 생성한다.
        let seoul = MapPoint(longitude: 126.875689, latitude: 37.4928896)
        let pusan = MapPoint(longitude: 128.774832, latitude: 35.126031)
        let points = Primitives.getCurvePoints(startPoint: seoul, endPoint: pusan, isLeft: false)
        
        // 생성한 곡선 points를 이용하여 Route를 생성한다.
        let options = RouteOptions(routeID: "route1", styleID: "routeStyleSet", zOrder: 0)
        options.segments = [RouteSegment(points: points, styleIndex: 0)]
        
        let route = layer?.addRoute(option: options)
        route?.show()
        
        mapView?.moveCamera(CameraUpdate.make(area: AreaRect(points: [seoul, pusan])))
    }
}
