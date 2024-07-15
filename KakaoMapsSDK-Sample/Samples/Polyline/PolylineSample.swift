//
//  PolylineSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/07/01.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

// Polyline 예제.
// Polyline은 지도상에 임의의 선을 그리고자 할 때에 사용한다.
class PolylineSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createPolylineStyleSet()
        createPolylineShape()
    }
    
    // StyleSet을 생성한다.
    // PolylineStyleSet은 한 개 이상의 PolylineStyle로 구성되고, PolylineStyle은 한 개 이상의 레벨별 스타일인 PerLevelPolylineStyle로 구성된다.
    // PerLevelPolylineStyle은 지정된 Polyline이 해당 레벨에서 어떻게 그려질지를 결정한다. 스타일이 지정되지 않았거나, 해당 레벨이 스타일이 지정되지 않은 구간이라면 Polyline은 그려지지 않는다.
    func createPolylineStyleSet() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let _ = manager.addShapeLayer(layerID: "PolylineLayer", zOrder: 10000)
        
        // 0 ~ 13레벨 : 빨간색 외곽선을 갖는 파란색 polyline
        // 14 ~ 16레벨 : 초록색 외곽선을 갖는 빨간색 polyline
        // 17 ~ 21레벨 : 빨간색 외곽선을 갖는 초록색 polyline
        let polylineStyle = PolylineStyle(styles: [
            PerLevelPolylineStyle(bodyColor: UIColor.blue, bodyWidth: 4, strokeColor: UIColor.red, strokeWidth: 1, level: 0),
            PerLevelPolylineStyle(bodyColor: UIColor.red, bodyWidth: 8, strokeColor: UIColor.green, strokeWidth: 2, level: 14),
            PerLevelPolylineStyle(bodyColor: UIColor.green, bodyWidth: 16, strokeColor: UIColor.red, strokeWidth: 3, level: 17)
        ])
        
        // 하나의 PolylineStyle을 포함하는 PolylineStyleSet을 만든다.
        let styleSet = PolylineStyleSet(styleSetID: "polylineStyleSet", styles: [polylineStyle])
        manager.addPolylineStyleSet(styleSet)
    }
    
    func createPolylineShape() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        /// ShapeLayer추가
        let layer = manager.getShapeLayer(layerID: "PolylineLayer")
        let basePosition = MapPoint(longitude: 127.044395, latitude: 37.505754)
        let options = PolylineShapeOptions(shapeID: "polyline", styleID: "polylineStyleSet", zOrder: 1)
        options.basePosition = basePosition
        options.polylines.append(Polyline(line: Primitives.getCirclePoints(radius: 100, numPoints: 90, cw: true), styleIndex: 0))

        let polyline = layer?.addPolylineShape(options)
        polyline?.show()
        
        mapView.moveCamera(CameraUpdate.make(cameraPosition: CameraPosition(target: basePosition, height: 500, rotation: 0, tilt: 0))) 
    }
}
