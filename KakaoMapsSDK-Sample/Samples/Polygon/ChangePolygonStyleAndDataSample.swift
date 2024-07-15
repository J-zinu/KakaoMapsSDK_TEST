//
//  ChangePolygonStyleAndDataSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// PolygonShape의 changeStyleAndData를 이용하는 예제
// 폴리곤을 만들고 1초에 한번씩 styleIndex가 다른 새로운 polygon을 append 한다.
// PolygonShape의 changeStyleAndData는 id는 변하지 않는 상태에서 polygon을 구성하는 좌표나 styleIndex, 혹은 사용하는 styleSet이 바뀌는 경우에 사용한다.
class ChangePolygonStyleAndDataSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        _timer?.invalidate()
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createShapeLayer()
        createPolygonStyleSet()
        createPolygonShape()
    }
    
    // PolygonShape를 추가하기 위해 ShapeLayer를 생성한다.
    func createShapeLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let _ = manager.addShapeLayer(layerID: "polygons", zOrder: 10001)
    }
    
    // PolygonShape에서 사용할 스타일셋을 만든다.
    func createPolygonStyleSet() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        // color가 다른 5개의 PolylineStyle을 만들어서 Set을 구성한다.
        let colors = [ UIColor(hex: 0xff000088),
                       UIColor(hex: 0x00ff0088),
                       UIColor(hex: 0x0000ff88),
                       UIColor(hex: 0x00ffff88),
                       UIColor(hex: 0xffff0088)]
        
        let storkeColors = [ UIColor(hex: 0xff0000ff),
                             UIColor(hex: 0x00ff00ff),
                             UIColor(hex: 0x0000ffff),
                             UIColor(hex: 0x00ffffff),
                             UIColor(hex: 0xffff00ff)]
        
        let styleSet = PolygonStyleSet(styleSetID: "polygonStyleSet")
        for index in 0 ..< colors.count {
            let perLevelStyle = PerLevelPolygonStyle(color: colors[index], strokeWidth: 3, strokeColor: storkeColors[index], level: 0)
            let style = PolygonStyle(styles: [perLevelStyle])
            
            styleSet.addStyle(style)
        }

        manager.addPolygonStyleSet(styleSet)
    }
    
    // 하나의 원으로 구성된 PolygonShape를 만든다.
    func createPolygonShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.getShapeLayer(layerID: "polygons")
        let center = MapPoint(longitude: 127.038575, latitude: 37.499699)
        
        _polygons = [MapPolygon]()
        _polygons?.append(MapPolygon(exteriorRing: Primitives.getCirclePoints(radius: 300, numPoints: 90, cw: true, center: center), hole: nil, styleIndex: 0))
        
        let option = MapPolygonShapeOptions(shapeID: "polygonShape", styleID: "polygonStyleSet", zOrder: 0)
        option.polygons = _polygons!
        
        let _ = layer?.addMapPolygonShape(option) { (polygon: MapPolygonShape?) -> Void in
            polygon?.show()
            mapView.moveCamera(CameraUpdate.make(target: center, zoomLevel: 15, mapView: mapView))
        }
    }
    
    // 1초에 한번씩 PolygonShape 업데이트
    // 랜덤한 위치에 랜덤 크기로 원을 생성하고, styleIndex도 랜덤하게 지정한다.
    @objc func onUpdatePolygon() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.getShapeLayer(layerID: "polygons")
        let polygonShape = layer?.getMapPolygonShape(shapeID: "polygonShape")
        
        let offset = Double.random(in: 0...0.004491)
        let center = MapPoint(longitude: 127.038575 + offset, latitude: 37.499699 + offset)
        let polygon = MapPolygon(exteriorRing: Primitives.getCirclePoints(radius: Double(arc4random_uniform(500)), numPoints: 90, cw: true, center: center), hole: nil, styleIndex: UInt(arc4random_uniform(5)))
        
        _polygons?.append(polygon)
        
        polygonShape?.changeStyleAndData(styleID: "polygonStyleSet", polygons: _polygons!)
        
        if _polygons!.count > 10 {
            _timer?.invalidate()
        }
    }
    
    @IBAction func onUpdateBtnClicked(_ sender: Any) {
        // 1초에 한번씩 update하는 runloop추가
        _timer = Timer.init(timeInterval: 1, target: self, selector: #selector(onUpdatePolygon), userInfo: nil, repeats: true)
         RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
    }
    
    var _polygons: [MapPolygon]?
    var _timer: Timer?
}
