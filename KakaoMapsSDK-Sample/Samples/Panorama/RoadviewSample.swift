//
//  Roadview.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/02.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// 로드뷰 예제.
class RoadviewSample: APISampleBaseViewController {
    required init?(coder aDecoder: NSCoder) {
        _minimap = false
        super.init(coder: aDecoder)
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        let roadviewInfo: RoadviewInfo = RoadviewInfo(viewName: "roadview", viewInfoName: "roadview", enabled: true)
        //미니맵을 위한 지도뷰 추가.
        mapController?.addView(mapviewInfo)
        //로드뷰 추가.
        mapController?.addView(roadviewInfo)
    }
    
    override func viewInit(viewName: String) {
        if viewName == "mapview" {
            print("mapview OK")
            let view = mapController?.getView("mapview") as! KakaoMap
            view.viewRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        if viewName == "roadview" {
            print("Roadview OK")
            requestRoadview()
        }
    }
    
    func requestRoadview() {
        let view = mapController?.getView("roadview") as! Roadview
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        
        // RoadviewLookAt지정
        // 요청한 로드뷰로 진입할 때 화면에 표시될 때 바라볼 방향(pan, tilt) 혹은 바라볼 위치(position)를 지정할 수 있다.
        let lookAt = RoadviewLookAt(pan: 0.5, tilt: 0.2)
        
        // PanoramaMarker지정
        // 로드뷰의 특정 direction(pan, tilt)이나 위치(position)을 마커로 표시할 수 있다.
        // direction type의 경우 특정 pan/tilt 의 방향에 마커를 표시하고,
        // position type의 경우 특정 position에 마커를 표시한다.
        let markers = [
            PanoramaMarker(pan: 0.5, tilt: 0.2),
        ]
        
        // 좌표로 로드뷰 요청. panoID를 알 경우, panoID를 지정할 수 있다. panoID가 지정되면 해당 panoID로 먼저 검색한 뒤 없으면 좌표로 검색한다.
        // 로드뷰를 요청할 때, RoadviewLookAt과 PanoramaMarker를 함께 전달한다.
        view.requestRoadview(position: defaultPosition, panoID: nil, markers: markers, lookAt: lookAt)
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        let roadview: Roadview? = mapController?.getView("roadview") as? Roadview
        
        if _minimap {
            roadview?.viewRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height * 0.5)
            mapView?.viewRect = CGRect(x: 0.0, y: size.height * 0.5, width: size.width, height: size.height * 0.5)
        }
        else {
            roadview?.viewRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            mapView?.viewRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    @IBAction func minimapButtonClicked(_ sender: Any) {
        _minimap = !_minimap
        
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        let roadview: Roadview? = mapController?.getView("roadview") as? Roadview
        //로드뷰와 미니맵뷰를 연결한다.
        roadview?.linkMapView("mapview")
        
        //미니맵 on/off 상태에 따라 크기를 조절한다.
        if _minimap {
            roadview?.viewRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height * 0.65)
            mapView?.viewRect = CGRect(x: 0.0, y: self.view.bounds.size.height * 0.65, width: self.view.bounds.size.width, height: self.view.bounds.size.height * 0.35)
        }
        else {
            roadview?.viewRect = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            mapView?.viewRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
   
    @IBOutlet weak var minimapButton: UIButton!
    var _minimap: Bool
}
