//
//  CameraManipulate.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/03.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class CameraManipulate: APISampleBaseViewController {
    
    required init?(coder aDecoder: NSCoder) {
        _pois = [Poi]()
        super.init(coder: aDecoder)
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("mapview OK")
        setDefaultOptions()
        setDefaultGui()
        createPois()
        createRect()
    }
    
    func setDefaultOptions() {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.cameraAnimationEnabled = true    //카메라 애니메이션 활성화. 애니메이션을 비활성화하면 animateCamera를 호출해도 moveCamera 처럼 애니메이션 없이 바로 이동한다.
        view.setBackToNorthDuringAutoElevation(true)    //활성화시 Auto Elevation 동작시 정북방향으로 카메라 방향을 초기화시킨다.
        
        _defaultCameraPosition = CameraUpdate.make(mapView: view)   //현재 뷰의 카메라 위치를 기억하는 CameraUpdate 객체를 생성.
    }
    
    func setDefaultGui() {
        let view = mapController?.getView("mapview") as! KakaoMap
        //나침판의 위치를 지정하고 보여주도록 설정.
        view.setCompassPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .left), position: CGPoint(x: 10.0, y: 10.0))
        view.showCompass()
    }
    
    //영역을 표시하기 위한 사각형 모서리에 POI를 추가. POI 예제 참조.
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 0)
        let layer = manager.addLabelLayer(option: layerOption)

        let iconStyle = PoiIconStyle(symbol: UIImage(named: "mapIcoBookmark_01.png"))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)

        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = 0
        let position1 = MapPoint(longitude: 126.996, latitude: 37.533)

        let poi1 = layer?.addPoi(option:poiOption, at: position1)
        _pois.append(poi1!)
        
        let position2 = MapPoint(longitude: 126.996, latitude: 37.540)
        let poi2 = layer?.addPoi(option:poiOption, at: position2)
        _pois.append(poi2!)
        
        let position3 = MapPoint(longitude: 127.0, latitude: 37.533)
        let poi3 = layer?.addPoi(option:poiOption, at: position3)
        _pois.append(poi3!)
        
        let position4 = MapPoint(longitude: 127.0, latitude: 37.540)
        let poi4 = layer?.addPoi(option:poiOption, at: position4)
        _pois.append(poi4!)
    }
    
    //영역을 표시하기 위한 사각형을 추가. Shape 예제 참조.
    func createRect() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getShapeManager()
        let layer = manager.addShapeLayer(layerID: "shapeLayer", zOrder: 10001)
        
        let shapeStyle = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 0.5), level: 0)
        ])
        let shapeStyleSet = PolygonStyleSet(styleSetID: "shapeLevelStyle", styles: [shapeStyle])
        manager.addPolygonStyleSet(shapeStyleSet)
        
        let options = MapPolygonShapeOptions(shapeID: "waveShape", styleID: "shapeLevelStyle", zOrder: 1)
        let points = [MapPoint(longitude: 126.996, latitude: 37.533),
                      MapPoint(longitude: 126.996, latitude: 37.540),
                      MapPoint(longitude: 127.0, latitude: 37.540),
                      MapPoint(longitude: 127.0, latitude: 37.533)]
        let polygon = MapPolygon(exteriorRing: points, hole: nil, styleIndex: 0)
        
        options.polygons.append(polygon)
        
        let shape = layer?.addMapPolygonShape(options)
        shape?.show()
    }
    
    @IBAction func cameraAnimationSwitchChanged(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.cameraAnimationEnabled = cameraAnimationSwitch.isOn
    }
    
    @IBAction func autoElevationSwitchChanged(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.setBackToNorthDuringAutoElevation(autoElevationSwitch.isOn)
    }
    
    @IBAction func buttonAClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        //특정 지점, 레벨, 회전, 틸트로 이동하는 CameraUpdate를 생성.
        let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: 126.798862, latitude: 37.546086), zoomLevel: 15, rotation: 1.7, tilt: 0.0, mapView: view)
        
        //지정한 CameraUpdate 대로 카메라 애니메이션을 시작한다.
        //애니메이션의 옵션을 지정할 수 있다.
        //autoElevation : 장거리 이동시 카메라 높낮이를 올려 이동을 잘 보이도록 하는 애니메이션.
        //consecutive : animateCamera를 연속적으로 호출하는 경우, 각 애니메이션을 이어서 연속적으로 수행한다.
        //durationInMiliis : 애니메이션 동작시간(ms).
        view.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: false, consecutive: true, durationInMillis: 2000))
    }
    
    @IBAction func buttonBClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        //레벨만 조정하는 CameraUpdate를 생성.
        let cameraUpdate = CameraUpdate.make(zoomLevel: 10, mapView: view)
        //애니메이션 없이 CameraUpdate에 지정된대로 카메라를 즉시 조정.
        view.moveCamera(cameraUpdate)
    }
    
    @IBAction func buttonCClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        //이전에 기억했던 위치로 돌아가는 애니메이션.
        view.animateCamera(cameraUpdate: _defaultCameraPosition!, options: CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 2000))
    }
    
    @IBAction func buttonDCilcked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        var points:[MapPoint] = [MapPoint]()
        
        for poi in _pois {
            poi.show()
            points.append(poi.position)
        }
        
        // 특정 범위가 모두 보이는 최대레벨의 위치로 카메라를 이동시키는 CameraUpdate를 생성한다.
        let cameraUpdate = CameraUpdate.make(area: AreaRect(points: points))
        view.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 2000))
    }
    var _defaultCameraPosition: CameraUpdate?
    var _pois: [Poi]
    @IBOutlet weak var cameraAnimationSwitch: UISwitch!
    @IBOutlet weak var autoElevationSwitch: UISwitch!
}
