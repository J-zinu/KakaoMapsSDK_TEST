//
//  ChangePolylineDataAndStyleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// PolylineShape의 changeStyleAndData를 이용하는 예제
// 폴리라인을 만들고, 0.5초에 한번씩 라인의 스타일 인덱스와 폴리라인을 구성하는 점을 추가해나간다.
// PolylineShape의 changestyleAndData는 id는 변하지 않는 상태에서 polyline을 구성하는 좌표나 styleIndex, 혹은 사용하는 styleSet이 바뀌는 경우에 사용한다.
class ChangePolylineDataAndStyleSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        _timer?.invalidate()
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        createShapeLayer()
        createPolylineStyleSet()
        createPolylineShape()
    }
    
    // PolylineShape 추가하기 위해 ShapeLayer를 생성한다.
    func createShapeLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let _ = manager.addShapeLayer(layerID: "polylines", zOrder: 10001)
    }
    
    // PolylineShape에서 사용할 스타일 셋을 만든다.
    func createPolylineStyleSet() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        
        // storkeColor만 다른 5개의 PolylineStyle을 만들어서 Set을 구성한다.
        let storkeColors = [ UIColor(hex: 0xff0000ff),
                             UIColor(hex: 0x00ff00ff),
                             UIColor(hex: 0x0000ffff),
                             UIColor(hex: 0x00ffffff),
                             UIColor(hex: 0xffff00ff)]
        
        let styleSet = PolylineStyleSet(styleSetID: "polylineStyleSet")
        for index in 0 ..< storkeColors.count {
            let perLevelStyle = PerLevelPolylineStyle(bodyColor: UIColor.white, bodyWidth: 10, strokeColor: storkeColors[index], strokeWidth: 2, level: 0)
            let style = PolylineStyle(styles: [perLevelStyle])
            
            styleSet.addStyle(style)
        }
        
        manager.addPolylineStyleSet(styleSet)
    }
    
    // PolylineShape를 만든다. Polyline은 기본적으로 2개 이상의 점으로 이루어진다.
    func createPolylineShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.getShapeLayer(layerID: "polylines")
        
        _points = [MapPoint]()
        _points?.append(MapPoint(longitude: 127.038575, latitude: 37.499699))
        _points?.append(MapPoint(longitude: 127.047558, latitude: 37.499699))
        
        let option = MapPolylineShapeOptions(shapeID: "line", styleID: "polylineStyleSet", zOrder: 0)
        option.polylines = [MapPolyline(line: _points!, styleIndex: 0)]
        
        let polyline = layer?.addMapPolylineShape(option)
        polyline?.show()
        
        // PolylineShape가 표시되는 곳으로 카메라 이동
        mapView.moveCamera(CameraUpdate.make(target: MapPoint(longitude: 127.038575, latitude: 37.499699), zoomLevel: 15, mapView: mapView))
    }
    
    // 0.5초에 한번씩 수행. 추가된 폴리라인에 점 하나를 랜덤하게 추가해나간다.
    // styleIndex는 추가한 styleSet의 5개의 스타일중 하나를 랜덤하게 사용한다.
    @objc func onUpdatePolyline() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let manager = mapView.getShapeManager()
        let layer = manager.getShapeLayer(layerID: "polylines")
        let line = layer?.getMapPolylineShape(shapeID: "line")
        
        // line을 구성하는 point 추가
        let pnt = (_points!.last?.wgsCoord)!
        _points?.append(MapPoint(longitude: pnt.longitude + Double.random(in: 0...0.004491),
                                 latitude: pnt.latitude + Double.random(in: 0...0.004491)))
        
        // Polyline segment 생성. styleIndex는 5개중에 하나를 선택한다.
        let lineSeg = MapPolyline(line: _points!, styleIndex: UInt(arc4random_uniform(5)))
        
        // PolylineShape를 구성하는 lineSegment를 업데이트한다.
        line?.changeStyleAndData(styleID: "polylineStyleSet", lines: [lineSeg])
    }
    
    // 버튼을 클ㄹ릭하면 Timer를 동작시킨다.
    @IBAction func onUpdateBtnClicked(_ sender: Any) {
    
        // 0.5초에 한번씩 update하는 runloop추가
        _timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(onUpdatePolyline), userInfo: nil, repeats: true)
         RunLoop.current.add(_timer!, forMode: RunLoop.Mode.common)
    }
    
    var _timer: Timer?
    var _points: [MapPoint]?
}
