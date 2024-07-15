//
//  Samples.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/01.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation

struct Sample {
    var className: String
    var title: String
}

struct SampleGroup {
    var title: String
    var samples: [Sample]
}

let sampleGroups: Array<SampleGroup> = [
    
    SampleGroup(title: "Basics", samples: [Sample(className: "SimpleMapView", title: "Simple map view"),
                                           Sample(className: "TabBarSample", title: "Use multiple mapViews with SwiftUI"),
                                           Sample(className: "CameraManipulate", title: "Manipulate camera"),
                                           Sample(className: "MarginTestSample", title: "Setting Margins of map view"),
                                           Sample(className: "BuildingHeightSample", title: "Adjust BuildingScale"),
                                           Sample(className: "FirstMapViewController", title: "Control Single KakaoMap"),
                                           Sample(className: "TextStyleSample", title: "TextStyle Settings"),
                                           Sample(className: "ExternalFontSample", title: "Use external fonts")
                                          ]),
    
    SampleGroup(title: "POI", samples: [Sample(className: "SimplePOI", title: "Add/remove POI, click event"),
                                        Sample(className: "POIBadgeSample", title: "POI badges"),
                                        Sample(className: "POIPerLevelStylesSample", title: "Per level styles, in style badges"),
                                        Sample(className: "POIStyleChangeSample", title: "Change POI's style"),
                                        Sample(className: "ChangePOITextAndStyleSample", title: "Change POI's style & text"),
                                        Sample(className: "LodPOISample", title: "Lod-POI"),
                                        Sample(className: "MovingPOISample", title: "Moving POI along a path"),
                                        Sample(className: "POIAnimationSample", title: "POI animations"),
                                        Sample(className: "ComplexPOIAnimationSample", title: "Complex POI animations"),
                                        Sample(className: "WaveTextSample", title: "WaveText"),
                                        Sample(className: "ChangeWaveTextDataAndStyleSample", title: "Change WaveText's style & text"),
                                        Sample(className: "PoiPixelOffsetSample", title: "POI pixel offset"),
                                        Sample(className: "RecoveryPoiSample", title: "Recovery Pois"),
                                        Sample(className: "PoiTransitionSample", title: "Poi Transition"),
                                        Sample(className: "PositionSharePoiSample", title: "Poi sharing position with poi")]),

    SampleGroup(title: "Polygon", samples: [Sample(className: "SimpleShape", title: "Simple shape"),
                                            Sample(className: "PerLevelStyledShapeSample", title: "Per level styled shape"),
                                            Sample(className: "ChangePolygonStyleAndDataSample", title: "Change Polygon style & data"),
                                            Sample(className: "DimScreenSample", title: "DimScreen"),
                                            Sample(className: "SimpleMapPolygonShapeSample", title: "SimpleMapPolygonShapeSample")]),
    
    SampleGroup(title: "Polyline", samples: [Sample(className: "PolylineSample", title: "Draw polyline"),
                                             Sample(className: "MapPolylineSample", title: "Draw MapPolyline"),
                                             Sample(className: "ChangePolylineDataAndStyleSample", title: "Change Polyline style & data"),
                                             Sample(className: "PolylineCapSample", title: "Polyline Cap Style")]),
    
    SampleGroup(title: "Route", samples: [Sample(className: "RouteLineSample", title: "Draw route line"),
                                          Sample(className: "ChangeEnabledRouteStyleSample", title: "Change route enabled/disabled style"),
                                          Sample(className: "ChangeRouteStyleAndDataSample", title: "Change route style"),
                                          Sample(className: "CurvedRouteSample", title: "Draw route using curved points")]),
    
    SampleGroup(title: "GUI", samples: [Sample(className: "BasicGUISample", title: "Basic GUI"),
                                        Sample(className: "InfoWindowSample", title: "InfoWindow"),
                                        Sample(className: "InfoWindowAnimationSample", title: "InfoWindow Animation"),
                                        Sample(className: "SpriteGUISample", title: "SpriteGUI"),
                                        Sample(className: "InfoWindowLayoutSample", title: "InfoWindow Layout sample")]),
    
    SampleGroup(title: "Panorama", samples: [Sample(className: "RoadviewSample", title: "Roadview")]),
    
    SampleGroup(title: "Service Example", samples: [Sample(className: "CurrentPositionPOI", title: "CurrentPositionPOI"),
                                                    Sample(className: "JejuBusSample", title: "JejuBus using Poi, PolygonShape"),
                                                    Sample(className: "SharedLocationSample", title: "Shared Location"),
                                                    Sample(className: "PoiClickServiceSample", title: "Click Service"),
                                                    Sample(className: "MapPolygonShapeSample", title: "MapPolygonShape")]),
    
    SampleGroup(title: "EventHandler Example", samples: [Sample(className: "CameraEventHandlerSample", title: "CameraEventHandlerSample"),
                                                         Sample(className: "TappedEventHandler", title: "TappedEventHandler"),
                                                         Sample(className: "ApiCallbackSample", title: "Usage for callbacks")]),
    
    SampleGroup(title: "Change Mapview Example", samples: [Sample(className: "ChangeBaseMapSample", title: "Change MapviewInfo"),
                                                           Sample(className: "OverlayMapSample", title: "Overlay")])
]
