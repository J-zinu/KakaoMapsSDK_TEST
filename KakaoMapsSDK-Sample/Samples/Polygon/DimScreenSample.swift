//
//  DimScreenSAmple.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/15.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

// DimScreen을 사용해 지도를 Dim시키고 특정 영역을 강조해 표현하는 예제.
class DimScreenSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createDimScreenShape()
    }
    
    func createDimScreenShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let dimScreen: DimScreen = mapView.dimScreen
        let shapeStyle = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5), strokeWidth: 2, strokeColor: UIColor.blue, level: 0),
            PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5), strokeWidth: 2, strokeColor: UIColor.red, level: 15)
        ])
        let shapeStyleSet = PolygonStyleSet(styleSetID: "shapeLevelStyle1", styles: [shapeStyle])
        dimScreen.addPolygonStyleSet(shapeStyleSet)

        let viewSize = mapView.viewRect.size
        let options = PolygonShapeOptions(shapeID: "shape1", styleID: "shapeLevelStyle1", zOrder: 1)
        options.basePosition = mapView.getPosition(CGPoint(x: viewSize.width/2, y: viewSize.height/2))
        let outter = Polygon(exteriorRing: Primitives.getCirclePoints(radius: 1.0, numPoints: 90, cw: true), hole: Primitives.getCirclePoints(radius: 0.8, numPoints: 90, cw: false), styleIndex: 0)
        let mid = Polygon(exteriorRing: Primitives.getCirclePoints(radius: 0.6, numPoints: 90, cw: true), hole: Primitives.getCirclePoints(radius: 0.4, numPoints: 90, cw: false), styleIndex: 0)
        let inner = Polygon(exteriorRing: Primitives.getCirclePoints(radius: 0.2, numPoints: 90, cw: true), hole: nil, styleIndex: 0)
        
        options.polygons.append(outter)
        options.polygons.append(mid)
        options.polygons.append(inner)
        
        let shape = dimScreen.addHighlightPolygonShape(options)
        shape?.show()
        
        let effect = WaveAnimationEffect(datas: [
            WaveAnimationData(startAlpha: 0.8, endAlpha: 0.0, startRadius: 10.0, endRadius: 100.0, level: 0),
            WaveAnimationData(startAlpha: 0.8, endAlpha: 0.0, startRadius: 50, endRadius: 500, level: 15)
        ])
        effect.hideAtStop = true
        effect.interpolation = AnimationInterpolation(duration: 1500, method: .cubicOut)
        effect.playCount = 15
        
        let animator = dimScreen.addShapeAnimator(animatorID: "circleWave", effect: effect)
        
        // animaotr 추가.
        animator?.addPolygonShape(shape!)
        animator?.start()
    }
    
    @IBAction func dimScreenSwitchChanged(_ sender: Any) {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        mapView.dimScreen.isEnabled = dimScreenSwitch.isOn  // DimScreen을 on/off 한다.
        print("\(dimScreenSwitch.isOn)")
    }
    
    @IBOutlet weak var dimScreenSwitch: UISwitch!
    
}
