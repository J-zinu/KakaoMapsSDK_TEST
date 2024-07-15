//
//  SimpleMapPolygonShape.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/01/04.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

class SimpleMapPolygonShapeSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createPolygonStyleSet()
        createMapPolygonShape()
    }
    
    // MapPolygonShape에 적용할 styleSet을 생성한다.
    // styleSet은 하나 이상의 style 집합으로 이루어지고, style은 레벨별로 구성할 수 있다.
    // styleSet에 추가한 각각의 style은 인덱싱으로 적용할 수 있다.
    func createPolygonStyleSet() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        let levelStyle1 = PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.9), strokeWidth: 2, strokeColor: UIColor.red, level: 0)
        let levelStyle2 = PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.0, blue: 0.0, alpha: 0.5), strokeWidth: 2, strokeColor: UIColor.red, level: 15)
        
        let polygonStyle = PolygonStyle(styles: [levelStyle1, levelStyle2])
        let styleSet = PolygonStyleSet(styleSetID: "ShapeStyle", styles: [polygonStyle])
        
        manager.addPolygonStyleSet(styleSet)
    }
    
    func createMapPolygonShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        // shapeLayer 생성
        let layer = manager.addShapeLayer(layerID: "shape", zOrder: 10001)
        
        // MapPolygonShape를 생성하기 위한 MapPolygonShapeOptions 생성
        let options = MapPolygonShapeOptions(shapeID: "mapPolygonShape", styleID: "ShapeStyle", zOrder: 1)
        // MapPolygonShape를 구성하는 MapPolygon은 위경도 좌표계로 이루어진다.
        let polygon = MapPolygon(exteriorRing: [
            MapPoint(longitude: 127.10656, latitude: 37.40303),
            MapPoint(longitude: 127.10655, latitude: 37.40301),
            MapPoint(longitude: 127.10660, latitude: 37.40247),
            MapPoint(longitude: 127.10938, latitude: 37.40249),
            MapPoint(longitude: 127.10946, latitude: 37.40253),
            MapPoint(longitude: 127.10945, latitude: 37.40298)
        ], hole: nil, styleIndex: 0)
        options.polygons.append(polygon)
        
        let shape = layer?.addMapPolygonShape(options)
        shape?.show()
        
        let cameraUpdate = CameraUpdate.make(area: AreaRect(points: polygon.exteriorRing))
        mapView.moveCamera(cameraUpdate)
    }
}
