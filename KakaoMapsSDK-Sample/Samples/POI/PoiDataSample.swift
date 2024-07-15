//
//  PoiDataSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/07.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import CoreLocation

// Poi를 화면에 표시하기 위한 임의의 더미 데이터.
// 엔진 및 API는 관계없는 서비스 side의 데이터이며, 해당 예제에서는 임의로 지정함.
struct PoiData {
    var id: String
    var position: CLLocationCoordinate2D
    var styleID: String
    var name: String
}

// dummy data 생성
class PoiDataSample {
    static func createPoiData() -> [PoiData] {
        if datas.isEmpty == false {
            return datas
        }
        
        let center = CLLocationCoordinate2D(latitude: 37.533, longitude: 126.996)
        
        let styleIds = [
            "orange",
            "red",
            "green",
            "blue"
        ]
        
        for index in 0 ... 100 {
            let position = CLLocationCoordinate2D(latitude: center.latitude + drand48(),
                                                  longitude: center.longitude + drand48())
            let data = PoiData(id: "poi" + String(index),
                               position: position,
                               styleID: styleIds[Int(arc4random_uniform(4))],
                               name: "place" + String(index))
            
            datas.append(data)
        }
        
        return datas
    }

    static var datas = [PoiData]()
}
