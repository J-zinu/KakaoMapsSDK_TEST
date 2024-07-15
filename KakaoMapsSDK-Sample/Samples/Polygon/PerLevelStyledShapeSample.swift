//
//  PerLevelStyledShapeSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/15.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

// 레벨별 스타일을 활용하는 예제.
// 레벨별 스타일을 활용하면 shape이 레벨에 따라 다르게 보이도록 구성할 수 있다.
class PerLevelStyledShapeSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createPolygonStyleSet()
        createShape()
    }
    
    func createPolygonStyleSet() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getShapeManager()

        // 레벨별 스타일을 생성.
        let perLevelStyle1 = PerLevelPolygonStyle(color: UIColor(red: 0.3, green: 0.7, blue: 0.0, alpha: 1.0), strokeWidth: 1, strokeColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), level: 0)
        let perLevelStyle2 = PerLevelPolygonStyle(color: UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 1.0), strokeWidth: 1, strokeColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), level: 15)
        
        let perLevelStyle3 = PerLevelPolygonStyle(color: UIColor(red: 0.3, green: 0.9, blue: 0.4, alpha: 1.0), strokeWidth: 1, strokeColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), level: 0)
        let perLevelStyle4 = PerLevelPolygonStyle(color: UIColor(red: 0.9, green: 0.2, blue: 0.6, alpha: 1.0), strokeWidth: 1, strokeColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), level: 15)
        
        // 각 레벨별 스타일로 구성된 2개의 Polygon Style
        let shapeStyle1 = PolygonStyle(styles: [perLevelStyle1, perLevelStyle2])
        let shapeStyle2 = PolygonStyle(styles: [perLevelStyle3, perLevelStyle4])
        
        // PolygonStyle을 PolygonStyleSet에 추가.
        let shapeStyleSet = PolygonStyleSet(styleSetID: "shapeStyleSet", styles: [shapeStyle1, shapeStyle2])
        manager.addPolygonStyleSet(shapeStyleSet)
    }
    
    // 두 개의 원으로 구성된 shape을 생성한다.
    // 0~14, 15~21 레벨에서 적용되는 레벨별 스타일을 가지는 ShapeStyle을 두 개 만들어 하나의 셋에 저장한다.
    // 각각의 원은 각각 스타일 셋의 0번, 1번 ShapeStyle을 사용한다.
    func createShape() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getShapeManager()
        let layer = manager.addShapeLayer(layerID: "shapeLayer", zOrder: 10001)
        
        // 두 개의 원으로 구성된 PolygonShape을 생성.
        
        // 첫번째 폴리곤 -> styleSet의 0번째 index의 style을 사용한다.
        let points = Primitives.getCirclePoints(radius: 50, numPoints: 90, cw: true)
        let polygon = Polygon(exteriorRing: points, hole: nil, styleIndex: 0)
        
        // 두번째 폴리곤 -> styleSet의 1번째 index의 style을 사용한다.
        let points2 = points.map { (p: CGPoint) -> CGPoint in
            return CGPoint(x: p.x + 100, y: p.y)
        }
        let polygon2 = Polygon(exteriorRing: points2, hole: nil, styleIndex: 1)
        
        // 두개의 폴리곤( polygon, polygon2 )로 구성된 PolygonShape를 생성한다.
        let options = PolygonShapeOptions(shapeID: "CircleShape", styleID: "shapeStyleSet", zOrder: 1)
        options.basePosition = MapPoint(longitude: 126.978365, latitude: 37.566691)
        options.polygons.append(polygon)
        options.polygons.append(polygon2)
        let shape = layer?.addPolygonShape(options)
        shape?.show()
    }
    
    
}
