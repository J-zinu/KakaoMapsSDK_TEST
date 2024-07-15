//
//  MovingPOISample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// 임의의 경로를 따라 이동하는 POI 예제.
class MovingPOISample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createLabelLayer()
        createPoiStyle()
        createPois()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let levels = [5, 8, 12, 17, 20]
        var levelStyles = [PerLevelPoiStyle]()
        for level in levels {
            let fileName = "mapbusico_blue_" + String(level) + "_lv.png"
            let iconStyle = PoiIconStyle(symbol: UIImage(named: fileName))
            levelStyles.append(PerLevelPoiStyle(iconStyle: iconStyle, level: level))
        }
        
        let poiStyle = PoiStyle(styleID: "busStyle", styles: levelStyles)
        manager.addPoiStyle(poiStyle)
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let trackingManager = view.getTrackingManager() // POI를 따라서 카메라를 이동시키기 위한 Manager.
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let options = PoiOptions(styleID: "busStyle", poiID: "jejuBus_1")
        options.rank = 0
        options.transformType = .decal
        
        let bus = layer?.addPoi(option:options, at: pathData()[0])
        bus?.show()
        bus?.moveAndRotateOnPath(pathData(), baseRadian: 0.0, duration: 5000, cornerRadius: 4.0, jumpThreshold: 200.0)   //지정된 경로를 따라 duration동안 이동한다.
        view.moveCamera(CameraUpdate.make(target: pathData()[0], zoomLevel: 15, mapView: view))
        trackingManager.startTrackingPoi(bus!)  //bus POI를 따라 카메라가 이동하도록 한다.
    }
    
    func pathData() -> [MapPoint]
    {
        var points = [MapPoint]()

        points.append(MapPoint(longitude: 127.038948, latitude: 37.500873))
        points.append(MapPoint(longitude: 127.038865, latitude: 37.5))
        points.append(MapPoint(longitude: 127.038614, latitude: 37.5))
        points.append(MapPoint(longitude: 127.038575, latitude: 37.499699))
        points.append(MapPoint(longitude: 127.038546, latitude: 37.499683))
        points.append(MapPoint(longitude: 127.0385, latitude: 37.499665))
        points.append(MapPoint(longitude: 127.037799, latitude: 37.499455))
        points.append(MapPoint(longitude: 127.037622, latitude: 37.499383))
        points.append(MapPoint(longitude: 127.036793, latitude: 37.499142))
        points.append(MapPoint(longitude: 127.036676, latitude: 37.499109))
        points.append(MapPoint(longitude: 127.036645, latitude: 37.499105))
        points.append(MapPoint(longitude: 127.0366, latitude: 37.499116))
        points.append(MapPoint(longitude: 127.036198, latitude: 37.499312))
        points.append(MapPoint(longitude: 127.03618, latitude: 37.499323))
        points.append(MapPoint(longitude: 127.036165, latitude: 37.499339))
        points.append(MapPoint(longitude: 127.036156, latitude: 37.499355))
        points.append(MapPoint(longitude: 127.036099, latitude: 37.499475))
        points.append(MapPoint(longitude: 127.035939, latitude: 37.499818))
        points.append(MapPoint(longitude: 127.035905, latitude: 37.499899))
        points.append(MapPoint(longitude: 127.035871, latitude: 37.5))
        points.append(MapPoint(longitude: 127.035787, latitude: 37.500171))
        
        
        return points
    }
}
