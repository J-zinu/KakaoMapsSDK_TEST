////
////  SimpleMapPolygonShape.swift
////  KakaoMapOpenApi-Sample
////
////  Created by narr on 2021/01/04.
////  Copyright © 2021 kakao. All rights reserved.
////
//
//import Foundation
//import UIKit
//import KakaoMapsSDK
//
//class SimpleMapPolygonShapeSample: APISampleBaseViewController {
//
//    override func addViews() {
//        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
//        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
//
//        mapController?.addView(mapviewInfo)
//    }
//
//    override func viewInit(viewName: String) {
//        print("OK")
//        createPolygonStyleSet()
//        createMapPolygonShape()
//        createDimPolygonSet()
//        createDimScreenShape()
//
//    }
//
//
//
//
//
//
//
//    // MapPolygonShape에 적용할 styleSet을 생성한다.
//    // styleSet은 하나 이상의 style 집합으로 이루어지고, style은 레벨별로 구성할 수 있다.
//    // styleSet에 추가한 각각의 style은 인덱싱으로 적용할 수 있다.
//    func createPolygonStyleSet() {
//        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
//        let manager = mapView.getShapeManager()
//
//        let levelStyle1 = PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.9), strokeWidth: 2, strokeColor: UIColor.red, level: 0)
//        let levelStyle2 = PerLevelPolygonStyle(color: UIColor(red: 0.7, green: 0.0, blue: 0.0, alpha: 0.5), strokeWidth: 2, strokeColor: UIColor.red, level: 15)
//
//        let polygonStyle = PolygonStyle(styles: [levelStyle1, levelStyle2])
//        let styleSet = PolygonStyleSet(styleSetID: "ShapeStyle", styles: [polygonStyle])
//
//        manager.addPolygonStyleSet(styleSet)
//    }
//
//    func createMapPolygonShape() {
//        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
//        let manager = mapView.getShapeManager()
//
//        // shapeLayer 생성
//        let layer = manager.addShapeLayer(layerID: "shape", zOrder: 10001)
//
//        // MapPolygonShape를 생성하기 위한 MapPolygonShapeOptions 생성
//        let options = MapPolygonShapeOptions(shapeID: "mapPolygonShape", styleID: "ShapeStyle", zOrder: 1)
//        // MapPolygonShape를 구성하는 MapPolygon은 위경도 좌표계로 이루어진다.
//        let polygon = MapPolygon(exteriorRing: [
//            MapPoint(longitude: 127.10656, latitude: 37.40303),
//            MapPoint(longitude: 127.10655, latitude: 37.40301),
//            MapPoint(longitude: 127.10660, latitude: 37.40247),
//            MapPoint(longitude: 127.10938, latitude: 37.40249),
//            MapPoint(longitude: 127.10946, latitude: 37.40253),
//            MapPoint(longitude: 127.10945, latitude: 37.40298),
//            MapPoint(longitude: 127.10656, latitude: 37.40303)
//        ], hole: nil, styleIndex: 0)
//        options.polygons.append(polygon)
//
//        let shape = layer?.addMapPolygonShape(options)
//        shape?.show()
//
//
//        //카메라 업데이트 객체가 폴리곤 경계에 맞게 끔 뷰를 업데이트한다.
//        let cameraUpdate = CameraUpdate.make(area: AreaRect(points: polygon.exteriorRing))
//        mapView.moveCamera(cameraUpdate)
//    }
//
//    func createDimPolygonSet() {
//        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
//        mapView.dimScreen.isEnabled = true
//        let dimScreen: DimScreen = mapView.dimScreen
//
//        let shapeStyle = PolygonStyle(styles: [
//            //0~15까지 줌레벨별 폴리곤 스타일을 지정한다.
//            PerLevelPolygonStyle(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0), strokeWidth: 3, strokeColor: UIColor.red, level: 0),
//            PerLevelPolygonStyle(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0), strokeWidth: 3, strokeColor: UIColor.red, level: 15)
//        ])
//        let shapeStyleSet = PolygonStyleSet(styleSetID: "shapeLevelStyle", styles: [shapeStyle]) // styleSetId 는 내가 만들 id를 지정하는 것이고, styles는 shapesytle 객체를 넣어준다는 것이다.
//
//        dimScreen.addPolygonStyleSet(shapeStyleSet)
//    }
//
//    func createDimScreenShape() {
//        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
//        let dimScreen: DimScreen = mapView.dimScreen
//
//        let viewSize = mapView.viewRect.size
//        let options = MapPolygonShapeOptions(shapeID: "shape1", styleID: "shapeLevelStyle", zOrder: 1)
//
//        let dimPolygon = [
//            MapPoint(longitude: 127.10656, latitude: 37.40303),
//            MapPoint(longitude: 127.10655, latitude: 37.40301),
//            MapPoint(longitude: 127.10660, latitude: 37.40247),
//            MapPoint(longitude: 127.10938, latitude: 37.40249),
//            MapPoint(longitude: 127.10946, latitude: 37.40253),
//            MapPoint(longitude: 127.10945, latitude: 37.40298)
//        ]
//
//
//        //세종
////        let dimPolygon = [
////            MapPoint(longitude: 127.20793603234716, latitude: 36.71918904581354),
////                MapPoint(longitude: 127.20792684751393, latitude: 36.71917607776152),
////                MapPoint(longitude: 127.2078769797854, latitude: 36.71919046333673),
////                MapPoint(longitude: 127.20787710929177, latitude: 36.71918850565105),
////                MapPoint(longitude: 127.20792684751393, latitude: 36.71917607776152),
////                MapPoint(longitude: 127.20789089293503, latitude: 36.719119287386114),
////                MapPoint(longitude: 127.22822551880574, latitude: 36.708468998779054),
////                MapPoint(longitude: 127.22822008391248, latitude: 36.70845514952263),
////                MapPoint(longitude: 127.22823057936279, latitude: 36.70846556314337),
////                MapPoint(longitude: 127.28126367067202, latitude: 36.69057059579415),
////                MapPoint(longitude: 127.28125389722467, latitude: 36.69051337150437),
////                MapPoint(longitude: 127.28127028658162, latitude: 36.69055905464245),
////                MapPoint(longitude: 127.28529006643944, latitude: 36.690671454249056),
////                MapPoint(longitude: 127.28584071664231, latitude: 36.69054597487386),
////                MapPoint(longitude: 127.28695192725102, latitude: 36.69042227135924),
////                MapPoint(longitude: 127.28778966925744, latitude: 36.689957120324),
////            MapPoint(longitude: 127.28779203249857, latitude: 36.68993638868247),
////            MapPoint(longitude: 127.28802252401164, latitude: 36.689552489604154),
////            MapPoint(longitude: 127.29315875989967, latitude: 36.686891527960476),
////            MapPoint(longitude: 127.29555230314855, latitude: 36.68662128819838),
////            MapPoint(longitude: 127.29601000174823, latitude: 36.686182800890414),
////            MapPoint(longitude: 127.29666145531564, latitude: 36.68577021395261),
////            MapPoint(longitude: 127.30599100648968, latitude: 36.68286949025073),
////            MapPoint(longitude: 127.30675988177548, latitude: 36.6827048689683),
////            MapPoint(longitude: 127.30713492689173, latitude: 36.68241042349506),
////            MapPoint(longitude: 127.30762517941348, latitude: 36.68202247597364),
////            MapPoint(longitude: 127.30748615036502, latitude: 36.681368114350946),
////            MapPoint(longitude: 127.30553179956138, latitude: 36.67468315246674),
////            MapPoint(longitude: 127.30538838486908, latitude: 36.674441673790525),
////            MapPoint(longitude: 127.30524851798377, latitude: 36.674294354514494),
////            MapPoint(longitude: 127.30556452598307, latitude: 36.67353875289289),
////            MapPoint(longitude: 127.30542032525797, latitude: 36.673168100096746),
////            MapPoint(longitude: 127.30549221552579, latitude: 36.67283651265932),
////            MapPoint(longitude: 127.30598724495917, latitude: 36.67248987335183),
////            MapPoint(longitude: 127.3060918613474, latitude: 36.67224860128498),
////            MapPoint(longitude: 127.3059754062775, latitude: 36.671330718487695),
////            MapPoint(longitude: 127.30120529359405, latitude: 36.663241312164345),
////            MapPoint(longitude: 127.30101457836184, latitude: 36.66204722630182),
////            MapPoint(longitude: 127.29974560292538, latitude: 36.6621899850743),
////            MapPoint(longitude: 127.2985492684561, latitude: 36.66154602975927),
////            MapPoint(longitude: 127.29541403878942, latitude: 36.65980079903912),
////            MapPoint(longitude: 127.29505040306023, latitude: 36.65971297941831),
////            MapPoint(longitude: 127.29293929048616, latitude: 36.65983513867207),
////            MapPoint(longitude: 127.29209366753187, latitude: 36.65945103727195),
////            MapPoint(longitude: 127.28578748471577, latitude: 36.65007050207586),
////            MapPoint(longitude: 127.28517652597971, latitude: 36.650072617724085),
////            MapPoint(longitude: 127.28491958095898, latitude: 36.6499578569263),
////            MapPoint(longitude: 127.2844024803419, latitude: 36.64999247286601),
////            MapPoint(longitude: 127.28406227151227, latitude: 36.64941340737435),
////            MapPoint(longitude: 127.28410399092954, latitude: 36.64873572508502),
////            MapPoint(longitude: 127.28367087545615, latitude: 36.64870082346342),
////            MapPoint(longitude: 127.28346345107761, latitude: 36.647798764912515),
////            MapPoint(longitude: 127.28363057457275, latitude: 36.64735889925182),
////            MapPoint(longitude: 127.28332041653829, latitude: 36.64714120012397),
////            MapPoint(longitude: 127.28284968060139, latitude: 36.64696494268962),
////            MapPoint(longitude: 127.28269782918669, latitude: 36.646682032028856),
////            MapPoint(longitude: 127.28215673979534, latitude: 36.645641130659904),
////            MapPoint(longitude: 127.28161958747624, latitude: 36.645142891240766),
////            MapPoint(longitude: 127.28196914305916, latitude: 36.64406615879597),
////            MapPoint(longitude: 127.28277801148316, latitude: 36.642293808669294),
////            MapPoint(longitude: 127.28183221680469, latitude: 36.64193460486294),
////            MapPoint(longitude: 127.28058671166131, latitude: 36.6413784785834),
////            MapPoint(longitude: 127.28005813754115, latitude: 36.640885328523275),
////            MapPoint(longitude: 127.27988656819622, latitude: 36.64080330486722),
////            MapPoint(longitude: 127.27961014992174, latitude: 36.64073834655767),
////            MapPoint(longitude: 127.2795157376238, latitude: 36.640696890590334),
////            MapPoint(longitude: 127.27839024150103, latitude: 36.64135365962691),
////            MapPoint(longitude: 127.27835966321695, latitude: 36.6413551168914),
////            MapPoint(longitude: 127.27616210578105, latitude: 36.640412381239344),
////            MapPoint(longitude: 127.27605058136636, latitude: 36.64008306205531),
////            MapPoint(longitude: 127.27599535796874, latitude: 36.64008410673377),
////            MapPoint(longitude: 127.2767369516302, latitude: 36.63767625620222),
////            MapPoint(longitude: 127.276855106548, latitude: 36.63735861562898),
////            MapPoint(longitude: 127.27697767395216, latitude: 36.63712828438764),
////            MapPoint(longitude: 127.27736026492623, latitude: 36.6365905052916),
////            MapPoint(longitude: 127.27771025399251, latitude: 36.636302642278146),
////            MapPoint(longitude: 127.27837175171065, latitude: 36.63574915743992),
////            MapPoint(longitude: 127.27858432173299, latitude: 36.63550038442548),
////            MapPoint(longitude: 127.27892529425306, latitude: 36.63402556131637),
////            MapPoint(longitude: 127.27902427630545, latitude: 36.63384677243725),
////            MapPoint(longitude: 127.27932104825264, latitude: 36.633555610274726),
////            MapPoint(longitude: 127.2793510933541, latitude: 36.633540825060926),
////            MapPoint(longitude: 127.27939744629366, latitude: 36.63351802624119),
////            MapPoint(longitude: 127.27947818609803, latitude: 36.63350317681572),
////            MapPoint(longitude: 127.2849683694301, latitude: 36.63399776355129),
////            MapPoint(longitude: 127.28501783554661, latitude: 36.63377242859195),
////            MapPoint(longitude: 127.28724472009708, latitude: 36.63612087143955),
////            MapPoint(longitude: 127.28738504595137, latitude: 36.63606344996632),
////            MapPoint(longitude: 127.29140803581117, latitude: 36.63643738428618),
////            MapPoint(longitude: 127.29203474903925, latitude: 36.63583253404632),
////            MapPoint(longitude: 127.29220849637726, latitude: 36.634928296802194),
////            MapPoint(longitude: 127.29220512498176, latitude: 36.63491176926981),
////            MapPoint(longitude: 127.29167449391241, latitude: 36.63385086559311),
////            MapPoint(longitude: 127.29173502415274, latitude: 36.633781504223585),
////            MapPoint(longitude: 127.29188354422375, latitude: 36.62533979195654),
////            MapPoint(longitude: 127.29201158924211, latitude: 36.62503680851586),
////            MapPoint(longitude: 127.29218257100409, latitude: 36.624836998546606),
////            MapPoint(longitude: 127.29235957948262, latitude: 36.624747976910825),
////            MapPoint(longitude: 127.29640912078843, latitude: 36.61897500928468),
////            MapPoint(longitude: 127.2988830749215, latitude: 36.61866137747316),
////            MapPoint(longitude: 127.29960715850451, latitude: 36.6179441706347),
////            MapPoint(longitude: 127.29978773484743, latitude: 36.6176502922248),
////            MapPoint(longitude: 127.30006160734733, latitude: 36.61719374990013),
////            MapPoint(longitude: 127.30017576182085, latitude: 36.616790668896314),
////            MapPoint(longitude: 127.30026479634921, latitude: 36.61645113396209),
////            MapPoint(longitude: 127.30021766482857, latitude: 36.61596656129217),
////            MapPoint(longitude: 127.30165572963566, latitude: 36.61282251041858),
////            MapPoint(longitude: 127.30180732474165, latitude: 36.612813742418105),
////            MapPoint(longitude: 127.30118450511816, latitude: 36.61169662990931),
////            MapPoint(longitude: 127.30117659435365, latitude: 36.61161939554949),
////            MapPoint(longitude: 127.30145108811489, latitude: 36.6102314206329),
////            MapPoint(longitude: 127.30136195693741, latitude: 36.610216740714094),
////            MapPoint(longitude: 127.30143375493505, latitude: 36.609851223353004),
////            MapPoint(longitude: 127.30158956382209, latitude: 36.60929574246767),
////            MapPoint(longitude: 127.30120784386847, latitude: 36.609197696050984),
////            MapPoint(longitude: 127.30124089402007, latitude: 36.60907623286527),
////            MapPoint(longitude: 127.30129197178773, latitude: 36.608613273338456),
////            MapPoint(longitude: 127.30101381237412, latitude: 36.60853820440824),
////            MapPoint(longitude: 127.30193999755144, latitude: 36.60685746996796),
////            MapPoint(longitude: 127.30202753908316, latitude: 36.60676631763875),
////            MapPoint(longitude: 127.30287583178692, latitude: 36.60600731269453),
////            MapPoint(longitude: 127.30325392400887, latitude: 36.60565669184328),
////            MapPoint(longitude: 127.30360868658373, latitude: 36.60537205291443),
////            MapPoint(longitude: 127.30556397838414, latitude: 36.603598282327894),
////            MapPoint(longitude: 127.30572171142731, latitude: 36.6033783125467),
////            MapPoint(longitude: 127.30618464574755, latitude: 36.60256305382366),
////            MapPoint(longitude: 127.30629392100103, latitude: 36.602308124972),
////            MapPoint(longitude: 127.30632172368443, latitude: 36.59923307340224),
////            MapPoint(longitude: 127.3061252444229, latitude: 36.59871432467949),
////            MapPoint(longitude: 127.30591289254673, latitude: 36.598313530131335),
////            MapPoint(longitude: 127.30580654938737, latitude: 36.59810728893466),
////            MapPoint(longitude: 127.30574489208077, latitude: 36.59798782781937),
////            MapPoint(longitude: 127.30543640065345, latitude: 36.59738778445304),
////            MapPoint(longitude: 127.30532761615453, latitude: 36.597211089828335),
////            MapPoint(longitude: 127.30512342051841, latitude: 36.596867674817496),
////            MapPoint(longitude: 127.30505713854193, latitude: 36.59675365254544),
////            MapPoint(longitude: 127.3049473794867, latitude: 36.596641433665724),
////            MapPoint(longitude: 127.30480256565008, latitude: 36.596238885867244),
////            MapPoint(longitude: 127.30315798244679, latitude: 36.589846974834884),
////            MapPoint(longitude: 127.30300752377117, latitude: 36.58968543753862),
////            MapPoint(longitude: 127.30288110514343, latitude: 36.589550102456734),
////            MapPoint(longitude: 127.30250950787895, latitude: 36.58905850659543),
////            MapPoint(longitude: 127.30223806585866, latitude: 36.58884760675026),
////            MapPoint(longitude: 127.30049544412255, latitude: 36.587936355001645),
////            MapPoint(longitude: 127.29998377814003, latitude: 36.58774076773492),
////            MapPoint(longitude: 127.29984573680306, latitude: 36.58767276063294),
////            MapPoint(longitude: 127.29978682525449, latitude: 36.587582670781764),
////            MapPoint(longitude: 127.2996715620089, latitude: 36.58617366479687),
////            MapPoint(longitude: 127.29982091566156, latitude: 36.58595324983658),
////            MapPoint(longitude: 127.30000167360662, latitude: 36.58586481294991),
////            MapPoint(longitude: 127.30161150568016, latitude: 36.58545427729559),
////            MapPoint(longitude: 127.30182832566175, latitude: 36.585324551786805),
////            MapPoint(longitude: 127.30197765197165, latitude: 36.585122167600574),
////            MapPoint(longitude: 127.30302818816928, latitude: 36.58396619033335),
////            MapPoint(longitude: 127.30327772069175, latitude: 36.583761998763855),
////            MapPoint(longitude: 127.3052123595425, latitude: 36.58309331129594),
////            MapPoint(longitude: 127.30552151466463, latitude: 36.583039788597276),
////            MapPoint(longitude: 127.30576774283747, latitude: 36.58299570596346),
////            MapPoint(longitude: 127.30619480167914, latitude: 36.582979457899576),
////            MapPoint(longitude: 127.3085064868594, latitude: 36.58290189765557),
////            MapPoint(longitude: 127.30877554665159, latitude: 36.582831194766015),
////            MapPoint(longitude: 127.30972901381928, latitude: 36.58289902849866),
////            MapPoint(longitude: 127.30994418505533, latitude: 36.582896563286084),
////            MapPoint(longitude: 127.31034819768857, latitude: 36.582895821859324),
////            MapPoint(longitude: 127.31081598318389, latitude: 36.58290160402119),
////            MapPoint(longitude: 127.31118020778989, latitude: 36.58288736434708),
////            MapPoint(longitude: 127.31138358422945, latitude: 36.58288038342038),
////            MapPoint(longitude: 127.3198455901394, latitude: 36.58373875608678),
////            MapPoint(longitude: 127.32043558475397, latitude: 36.58373853119033),
////            MapPoint(longitude: 127.32088749519556, latitude: 36.58377362866443),
////            MapPoint(longitude: 127.32143936934834, latitude: 36.583779683168714),
////            MapPoint(longitude: 127.32272620113196, latitude: 36.58213375067179),
////            MapPoint(longitude: 127.32304543734186, latitude: 36.581915155734585),
////            MapPoint(longitude: 127.3227559560115, latitude: 36.581734582798425),
////            MapPoint(longitude: 127.32206277912906, latitude: 36.581494307205766),
////            MapPoint(longitude: 127.32177688022196, latitude: 36.58142010061243),
////            MapPoint(longitude: 127.32159783779174, latitude: 36.58137155982673),
////            MapPoint(longitude: 127.32149145640194, latitude: 36.581309521278094),
////            MapPoint(longitude: 127.3216283110897, latitude: 36.581069354885386),
////            MapPoint(longitude: 127.32492488890603, latitude: 36.58009508817309),
////            MapPoint(longitude: 127.32503258811488, latitude: 36.579915938565144),
////            MapPoint(longitude: 127.32502765818164, latitude: 36.579588549165955),
////            MapPoint(longitude: 127.32475727815836, latitude: 36.579022822135805),
////            MapPoint(longitude: 127.32531050395207, latitude: 36.57837084280806),
////            MapPoint(longitude: 127.32538481267486, latitude: 36.57811842189787),
////            MapPoint(longitude: 127.3254359215498, latitude: 36.57782247653914),
////            MapPoint(longitude: 127.3254549248763, latitude: 36.57771238013681),
////            MapPoint(longitude: 127.32573981497552, latitude: 36.577526403721244),
////            MapPoint(longitude: 127.32779035974866, latitude: 36.57589447536298),
////            MapPoint(longitude: 127.32788265003703, latitude: 36.57583716261832),
////            MapPoint(longitude: 127.32790905889074, latitude: 36.5757729205331),
////            MapPoint(longitude: 127.32805098940516, latitude: 36.57577673759555),
////            MapPoint(longitude: 127.3281758402883, latitude: 36.57574150644202),
////            MapPoint(longitude: 127.32881832948651, latitude: 36.57556636316261),
////            MapPoint(longitude: 127.32908280516796, latitude: 36.57535742216015),
////            MapPoint(longitude: 127.32942389524071, latitude: 36.57531337451181),
////            MapPoint(longitude: 127.32970417274994, latitude: 36.57498935412286),
////            MapPoint(longitude: 127.3344462746174, latitude: 36.57160151508699),
////            MapPoint(longitude: 127.3349901217512, latitude: 36.571431247627494),
////            MapPoint(longitude: 127.33573602887667, latitude: 36.570702852165844),
////            MapPoint(longitude: 127.33576934132576, latitude: 36.5706065082213),
////            MapPoint(longitude: 127.33617096660163, latitude: 36.57025631710134),
////            MapPoint(longitude: 127.33655020881913, latitude: 36.569986073887144),
////            MapPoint(longitude: 127.33620739544183, latitude: 36.56952049958285),
////            MapPoint(longitude: 127.33606719895977, latitude: 36.56933078804634),
////            MapPoint(longitude: 127.33575233431071, latitude: 36.56890475763566),
////            MapPoint(longitude: 127.33515454924374, latitude: 36.568096137968155),
////            MapPoint(longitude: 127.33546734029163, latitude: 36.56726329843188),
////            MapPoint(longitude: 127.33559099044388, latitude: 36.56710112640649),
////            MapPoint(longitude: 127.33584832797901, latitude: 36.56667752799316),
////            MapPoint(longitude: 127.33642085438704, latitude: 36.565554012778996),
////            MapPoint(longitude: 127.336584401099, latitude: 36.56534770780269),
////            MapPoint(longitude: 127.33662673183058, latitude: 36.56515687250125),
////            MapPoint(longitude: 127.33682386060448, latitude: 36.56427923203463),
////            MapPoint(longitude: 127.33684255298114, latitude: 36.56427749450982),
////            MapPoint(longitude: 127.33685970559493, latitude: 36.56424247321924),
////            MapPoint(longitude: 127.33688132076517, latitude: 36.56419839168468),
////            MapPoint(longitude: 127.34080478039098, latitude: 36.56364152551656),
////            MapPoint(longitude: 127.34086982579575, latitude: 36.56363593369186),
////            MapPoint(longitude: 127.34243191690224, latitude: 36.56372112268328),
////            MapPoint(longitude: 127.34324334759147, latitude: 36.56462472183839),
////            MapPoint(longitude: 127.34444211247006, latitude: 36.56435856255148),
////            MapPoint(longitude: 127.34446478563817, latitude: 36.56432467521305),
////            MapPoint(longitude: 127.34348871364591, latitude: 36.56441327636665),
////            MapPoint(longitude: 127.34339377058384, latitude: 36.56439283337752),
////            MapPoint(longitude: 127.34452911030007, latitude: 36.56401482451396),
////            MapPoint(longitude: 127.34738548273008, latitude: 36.564087098689406),
////            MapPoint(longitude: 127.34784963993853, latitude: 36.56385581697319),
////            MapPoint(longitude: 127.36825983291152, latitude: 36.566196532635615),
////            MapPoint(longitude: 127.40182466649642, latitude: 36.54124048495118),
////            MapPoint(longitude: 127.40982635082797, latitude: 36.495320806621656),
////            MapPoint(longitude: 127.40278189051706, latitude: 36.493414713499995),
////            MapPoint(longitude: 127.40029554490653, latitude: 36.49344405572545),
////            MapPoint(longitude: 127.3969998205258, latitude: 36.49234724550459),
////            MapPoint(longitude: 127.39612424170942, latitude: 36.49172477764016),
////            MapPoint(longitude: 127.39612055279709, latitude: 36.49172147304118),
////            MapPoint(longitude: 127.39575988535204, latitude: 36.49195602619904),
////            MapPoint(longitude: 127.38626339999793, latitude: 36.498985556577466),
////            MapPoint(longitude: 127.38538373894964, latitude: 36.499444883432616),
////            MapPoint(longitude: 127.38385497104343, latitude: 36.500230690026456),
////            MapPoint(longitude: 127.38230967353526, latitude: 36.49992444824916),
////            MapPoint(longitude: 127.38096688868224, latitude: 36.499660645040414),
////            MapPoint(longitude: 127.38033654837668, latitude: 36.49953929874922),
////            MapPoint(longitude: 127.38008138312885, latitude: 36.499215976257155),
////            MapPoint(longitude: 127.35579857644919, latitude: 36.450273038129),
////            MapPoint(longitude: 127.3263167270464, latitude: 36.422208976417835),
////            MapPoint(longitude: 127.29425168764308, latitude: 36.42219502183513),
////            MapPoint(longitude: 127.29426961581308, latitude: 36.421915039124464),
////            MapPoint(longitude: 127.28212428234082, latitude: 36.414603964631645),
////            MapPoint(longitude: 127.25790805131376, latitude: 36.40823236399692),
////            MapPoint(longitude: 127.20138964906599, latitude: 36.44197527604719),
////            MapPoint(longitude: 127.20473351147956, latitude: 36.45929024006822),
////            MapPoint(longitude: 127.17346586866955, latitude: 36.499206669441534),
////            MapPoint(longitude: 127.17266844902414, latitude: 36.536143615637876),
////            MapPoint(longitude: 127.19378772255222, latitude: 36.564812513911036),
////            MapPoint(longitude: 127.17865507176774, latitude: 36.59668359063944),
////            MapPoint(longitude: 127.1786181246923, latitude: 36.59671264216109),
////            MapPoint(longitude: 127.15547820292068, latitude: 36.606702898566276),
////            MapPoint(longitude: 127.15485840345418, latitude: 36.6642746537941),
////            MapPoint(longitude: 127.13437853561463, latitude: 36.7067919896922),
////            MapPoint(longitude: 127.15964389368695, latitude: 36.732843948327705),
////            MapPoint(longitude: 127.20793603234716, latitude: 36.71918904581354)
////
////        ]
//
//
//
//        let dim = MapPolygon(exteriorRing: dimPolygon, hole: nil, styleIndex: 0)
//
//        options.polygons.append(dim)
//
//
//        let shape = dimScreen.addHighlightMapPolygonShape(options)
//        shape?.show()
//
//    }
//
//    @objc public class ZoneManager : NSObject {
//
//        /// Zone의 유무를 체크하는 Rect 크기 지정.
//        /// Rect는 view의 중심에 위치한, ViewSize * xy scale 크기의 Rect가 된다. 해당 Rect 안에 zone이 들어올 경우 KakaoMapEventDelegate.onEnterZone이 호출된다.
//        /// Zone이 Rect밖으로 나갈 경우 KakaoMapEventDelegate.onLeaveZone이 호출된다.
//        ///
//        /// - parameters
//        ///     - zoneType: Zone의 type
//        ///     - level: scale 지정할 레벨.
//        ///     - scale: Scale 값(0.1~1.0). 기본값 (1.0, 1.0)
//        @objc public func setZoneCheckRectScale(zoneType: String, level: Int, scale: Vector2){
//
//        }
//
//        /// Zone의 상세 레이어를 표시한다.
//        /// detailId는 KakaoMapEventDelegate.onEnterZone로 전달되는 details 중에 선택할 수 있다.
//        ///
//        /// - parameters
//        ///     - zoneType: Zone의 type
//        ///     - zoneId: Zone의 ID
//        ///     - detailId: Zone의 상세 레이어 ID (ex. 1F)
//        @objc public func showZoneDetail(zoneType: String, zoneId: String, detailId: String){
//
//        }
//
//        /// Zone의 상세 레이어를 숨긴다.
//        ///
//        /// - parameter zoneType: 상세 레이어를 숨길 zone의 type
//        @objc public func hideZoneDetail(zoneType: String){
//
//        }
//    }
//
//
//
//
//
//
//
//}



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
        createDimPolygonSet()
        createDimScreenShape()
        
        // 좌표를 확인하는 부분 추가
        //        let testPoint = MapPoint(longitude: 127.106970, latitude: 37.402747) // 영역 내
        //        let testPoint = MapPoint(longitude: 37.408875, latitude: 127.118147) // 영역 외
        //        let dimPolygon = [
        //            MapPoint(longitude: 127.10656, latitude: 37.40303),
        //            MapPoint(longitude: 127.10655, latitude: 37.40301),
        //            MapPoint(longitude: 127.10660, latitude: 37.40247),
        //            MapPoint(longitude: 127.10938, latitude: 37.40249),
        //            MapPoint(longitude: 127.10946, latitude: 37.40253),
        //            MapPoint(longitude: 127.10945, latitude: 37.40298)
        //        ]
        
        
        
        let testPoint = MapPoint(longitude: 127.106970, latitude: 37.402747)
        let dimPolygon = [
            MapPoint(longitude: 127.20793603234716, latitude: 36.71918904581354),
            MapPoint(longitude: 127.20792684751393, latitude: 36.71917607776152),
            MapPoint(longitude: 127.2078769797854, latitude: 36.71919046333673),
            MapPoint(longitude: 127.20787710929177, latitude: 36.71918850565105),
            MapPoint(longitude: 127.20792684751393, latitude: 36.71917607776152),
            MapPoint(longitude: 127.20789089293503, latitude: 36.719119287386114),
            MapPoint(longitude: 127.22822551880574, latitude: 36.708468998779054),
            MapPoint(longitude: 127.22822008391248, latitude: 36.70845514952263),
            MapPoint(longitude: 127.22823057936279, latitude: 36.70846556314337),
            MapPoint(longitude: 127.28126367067202, latitude: 36.69057059579415),
            MapPoint(longitude: 127.28125389722467, latitude: 36.69051337150437),
            MapPoint(longitude: 127.28127028658162, latitude: 36.69055905464245),
            MapPoint(longitude: 127.28529006643944, latitude: 36.690671454249056),
            MapPoint(longitude: 127.28584071664231, latitude: 36.69054597487386),
            MapPoint(longitude: 127.28695192725102, latitude: 36.69042227135924),
            MapPoint(longitude: 127.28778966925744, latitude: 36.689957120324),
            MapPoint(longitude: 127.28779203249857, latitude: 36.68993638868247),
            MapPoint(longitude: 127.28802252401164, latitude: 36.689552489604154),
            MapPoint(longitude: 127.29315875989967, latitude: 36.686891527960476),
            MapPoint(longitude: 127.29555230314855, latitude: 36.68662128819838),
            MapPoint(longitude: 127.29601000174823, latitude: 36.686182800890414),
            MapPoint(longitude: 127.29666145531564, latitude: 36.68577021395261),
            MapPoint(longitude: 127.30599100648968, latitude: 36.68286949025073),
            MapPoint(longitude: 127.30675988177548, latitude: 36.6827048689683),
            MapPoint(longitude: 127.30713492689173, latitude: 36.68241042349506),
            MapPoint(longitude: 127.30762517941348, latitude: 36.68202247597364),
            MapPoint(longitude: 127.30748615036502, latitude: 36.681368114350946),
            MapPoint(longitude: 127.30553179956138, latitude: 36.67468315246674),
            MapPoint(longitude: 127.30538838486908, latitude: 36.674441673790525),
            MapPoint(longitude: 127.30524851798377, latitude: 36.674294354514494),
            MapPoint(longitude: 127.30556452598307, latitude: 36.67353875289289),
            MapPoint(longitude: 127.30542032525797, latitude: 36.673168100096746),
            MapPoint(longitude: 127.30549221552579, latitude: 36.67283651265932),
            MapPoint(longitude: 127.30598724495917, latitude: 36.67248987335183),
            MapPoint(longitude: 127.3060918613474, latitude: 36.67224860128498),
            MapPoint(longitude: 127.3059754062775, latitude: 36.671330718487695),
            MapPoint(longitude: 127.30120529359405, latitude: 36.663241312164345),
            MapPoint(longitude: 127.30101457836184, latitude: 36.66204722630182),
            MapPoint(longitude: 127.29974560292538, latitude: 36.6621899850743),
            MapPoint(longitude: 127.2985492684561, latitude: 36.66154602975927),
            MapPoint(longitude: 127.29541403878942, latitude: 36.65980079903912),
            MapPoint(longitude: 127.29505040306023, latitude: 36.65971297941831),
            MapPoint(longitude: 127.29293929048616, latitude: 36.65983513867207),
            MapPoint(longitude: 127.29209366753187, latitude: 36.65945103727195),
            MapPoint(longitude: 127.28578748471577, latitude: 36.65007050207586),
            MapPoint(longitude: 127.28517652597971, latitude: 36.650072617724085),
            MapPoint(longitude: 127.28491958095898, latitude: 36.6499578569263),
            MapPoint(longitude: 127.2844024803419, latitude: 36.64999247286601),
            MapPoint(longitude: 127.28406227151227, latitude: 36.64941340737435),
            MapPoint(longitude: 127.28410399092954, latitude: 36.64873572508502),
            MapPoint(longitude: 127.28367087545615, latitude: 36.64870082346342),
            MapPoint(longitude: 127.28346345107761, latitude: 36.647798764912515),
            MapPoint(longitude: 127.28363057457275, latitude: 36.64735889925182),
            MapPoint(longitude: 127.28332041653829, latitude: 36.64714120012397),
            MapPoint(longitude: 127.28284968060139, latitude: 36.64696494268962),
            MapPoint(longitude: 127.28269782918669, latitude: 36.646682032028856),
            MapPoint(longitude: 127.28215673979534, latitude: 36.645641130659904),
            MapPoint(longitude: 127.28161958747624, latitude: 36.645142891240766),
            MapPoint(longitude: 127.28196914305916, latitude: 36.64406615879597),
            MapPoint(longitude: 127.28277801148316, latitude: 36.642293808669294),
            MapPoint(longitude: 127.28183221680469, latitude: 36.64193460486294),
            MapPoint(longitude: 127.28058671166131, latitude: 36.6413784785834),
            MapPoint(longitude: 127.28005813754115, latitude: 36.640885328523275),
            MapPoint(longitude: 127.27988656819622, latitude: 36.64080330486722),
            MapPoint(longitude: 127.27961014992174, latitude: 36.64073834655767),
            MapPoint(longitude: 127.2795157376238, latitude: 36.640696890590334),
            MapPoint(longitude: 127.27839024150103, latitude: 36.64135365962691),
            MapPoint(longitude: 127.27835966321695, latitude: 36.6413551168914),
            MapPoint(longitude: 127.27616210578105, latitude: 36.640412381239344),
            MapPoint(longitude: 127.27605058136636, latitude: 36.64008306205531),
            MapPoint(longitude: 127.27599535796874, latitude: 36.64008410673377),
            MapPoint(longitude: 127.2767369516302, latitude: 36.63767625620222),
            MapPoint(longitude: 127.276855106548, latitude: 36.63735861562898),
            MapPoint(longitude: 127.27697767395216, latitude: 36.63712828438764),
            MapPoint(longitude: 127.27736026492623, latitude: 36.6365905052916),
            MapPoint(longitude: 127.27771025399251, latitude: 36.636302642278146),
            MapPoint(longitude: 127.27837175171065, latitude: 36.63574915743992),
            MapPoint(longitude: 127.27858432173299, latitude: 36.63550038442548),
            MapPoint(longitude: 127.27892529425306, latitude: 36.63402556131637),
            MapPoint(longitude: 127.27902427630545, latitude: 36.63384677243725),
            MapPoint(longitude: 127.27932104825264, latitude: 36.633555610274726),
            MapPoint(longitude: 127.2793510933541, latitude: 36.633540825060926),
            MapPoint(longitude: 127.27939744629366, latitude: 36.63351802624119),
            MapPoint(longitude: 127.27947818609803, latitude: 36.63350317681572),
            MapPoint(longitude: 127.2849683694301, latitude: 36.63399776355129),
            MapPoint(longitude: 127.28501783554661, latitude: 36.63377242859195),
            MapPoint(longitude: 127.28724472009708, latitude: 36.63612087143955),
            MapPoint(longitude: 127.28738504595137, latitude: 36.63606344996632),
            MapPoint(longitude: 127.29140803581117, latitude: 36.63643738428618),
            MapPoint(longitude: 127.29203474903925, latitude: 36.63583253404632),
            MapPoint(longitude: 127.29220849637726, latitude: 36.634928296802194),
            MapPoint(longitude: 127.29220512498176, latitude: 36.63491176926981),
            MapPoint(longitude: 127.29167449391241, latitude: 36.63385086559311),
            MapPoint(longitude: 127.29173502415274, latitude: 36.633781504223585),
            MapPoint(longitude: 127.29188354422375, latitude: 36.62533979195654),
            MapPoint(longitude: 127.29201158924211, latitude: 36.62503680851586),
            MapPoint(longitude: 127.29218257100409, latitude: 36.624836998546606),
            MapPoint(longitude: 127.29235957948262, latitude: 36.624747976910825),
            MapPoint(longitude: 127.29640912078843, latitude: 36.61897500928468),
            MapPoint(longitude: 127.2988830749215, latitude: 36.61866137747316),
            MapPoint(longitude: 127.29960715850451, latitude: 36.6179441706347),
            MapPoint(longitude: 127.29978773484743, latitude: 36.6176502922248),
            MapPoint(longitude: 127.30006160734733, latitude: 36.61719374990013),
            MapPoint(longitude: 127.30017576182085, latitude: 36.616790668896314),
            MapPoint(longitude: 127.30026479634921, latitude: 36.61645113396209),
            MapPoint(longitude: 127.30021766482857, latitude: 36.61596656129217),
            MapPoint(longitude: 127.30165572963566, latitude: 36.61282251041858),
            MapPoint(longitude: 127.30180732474165, latitude: 36.612813742418105),
            MapPoint(longitude: 127.30118450511816, latitude: 36.61169662990931),
            MapPoint(longitude: 127.30117659435365, latitude: 36.61161939554949),
            MapPoint(longitude: 127.30145108811489, latitude: 36.6102314206329),
            MapPoint(longitude: 127.30136195693741, latitude: 36.610216740714094),
            MapPoint(longitude: 127.30143375493505, latitude: 36.609851223353004),
            MapPoint(longitude: 127.30158956382209, latitude: 36.60929574246767),
            MapPoint(longitude: 127.30120784386847, latitude: 36.609197696050984),
            MapPoint(longitude: 127.30124089402007, latitude: 36.60907623286527),
            MapPoint(longitude: 127.30129197178773, latitude: 36.608613273338456),
            MapPoint(longitude: 127.30101381237412, latitude: 36.60853820440824),
            MapPoint(longitude: 127.30193999755144, latitude: 36.60685746996796),
            MapPoint(longitude: 127.30202753908316, latitude: 36.60676631763875),
            MapPoint(longitude: 127.30287583178692, latitude: 36.60600731269453),
            MapPoint(longitude: 127.30325392400887, latitude: 36.60565669184328),
            MapPoint(longitude: 127.30360868658373, latitude: 36.60537205291443),
            MapPoint(longitude: 127.30556397838414, latitude: 36.603598282327894),
            MapPoint(longitude: 127.30572171142731, latitude: 36.6033783125467),
            MapPoint(longitude: 127.30618464574755, latitude: 36.60256305382366),
            MapPoint(longitude: 127.30629392100103, latitude: 36.602308124972),
            MapPoint(longitude: 127.30632172368443, latitude: 36.59923307340224),
            MapPoint(longitude: 127.3061252444229, latitude: 36.59871432467949),
            MapPoint(longitude: 127.30591289254673, latitude: 36.598313530131335),
            MapPoint(longitude: 127.30580654938737, latitude: 36.59810728893466),
            MapPoint(longitude: 127.30574489208077, latitude: 36.59798782781937),
            MapPoint(longitude: 127.30543640065345, latitude: 36.59738778445304),
            MapPoint(longitude: 127.30532761615453, latitude: 36.597211089828335),
            MapPoint(longitude: 127.30512342051841, latitude: 36.596867674817496),
            MapPoint(longitude: 127.30505713854193, latitude: 36.59675365254544),
            MapPoint(longitude: 127.3049473794867, latitude: 36.596641433665724),
            MapPoint(longitude: 127.30480256565008, latitude: 36.596238885867244),
            MapPoint(longitude: 127.30315798244679, latitude: 36.589846974834884),
            MapPoint(longitude: 127.30300752377117, latitude: 36.58968543753862),
            MapPoint(longitude: 127.30288110514343, latitude: 36.589550102456734),
            MapPoint(longitude: 127.30250950787895, latitude: 36.58905850659543),
            MapPoint(longitude: 127.30223806585866, latitude: 36.58884760675026),
            MapPoint(longitude: 127.30049544412255, latitude: 36.587936355001645),
            MapPoint(longitude: 127.29998377814003, latitude: 36.58774076773492),
            MapPoint(longitude: 127.29984573680306, latitude: 36.58767276063294),
            MapPoint(longitude: 127.29978682525449, latitude: 36.587582670781764),
            MapPoint(longitude: 127.2996715620089, latitude: 36.58617366479687),
            MapPoint(longitude: 127.29982091566156, latitude: 36.58595324983658),
            MapPoint(longitude: 127.30000167360662, latitude: 36.58586481294991),
            MapPoint(longitude: 127.30161150568016, latitude: 36.58545427729559),
            MapPoint(longitude: 127.30182832566175, latitude: 36.585324551786805),
            MapPoint(longitude: 127.30197765197165, latitude: 36.585122167600574),
            MapPoint(longitude: 127.30302818816928, latitude: 36.58396619033335),
            MapPoint(longitude: 127.30327772069175, latitude: 36.583761998763855),
            MapPoint(longitude: 127.3052123595425, latitude: 36.58309331129594),
            MapPoint(longitude: 127.30552151466463, latitude: 36.583039788597276),
            MapPoint(longitude: 127.30576774283747, latitude: 36.58299570596346),
            MapPoint(longitude: 127.30619480167914, latitude: 36.582979457899576),
            MapPoint(longitude: 127.3085064868594, latitude: 36.58290189765557),
            MapPoint(longitude: 127.30877554665159, latitude: 36.582831194766015),
            MapPoint(longitude: 127.30972901381928, latitude: 36.58289902849866),
            MapPoint(longitude: 127.30994418505533, latitude: 36.582896563286084),
            MapPoint(longitude: 127.31034819768857, latitude: 36.582895821859324),
            MapPoint(longitude: 127.31081598318389, latitude: 36.58290160402119),
            MapPoint(longitude: 127.31118020778989, latitude: 36.58288736434708),
            MapPoint(longitude: 127.31138358422945, latitude: 36.58288038342038),
            MapPoint(longitude: 127.3198455901394, latitude: 36.58373875608678),
            MapPoint(longitude: 127.32043558475397, latitude: 36.58373853119033),
            MapPoint(longitude: 127.32088749519556, latitude: 36.58377362866443),
            MapPoint(longitude: 127.32143936934834, latitude: 36.583779683168714),
            MapPoint(longitude: 127.32272620113196, latitude: 36.58213375067179),
            MapPoint(longitude: 127.32304543734186, latitude: 36.581915155734585),
            MapPoint(longitude: 127.3227559560115, latitude: 36.581734582798425),
            MapPoint(longitude: 127.32206277912906, latitude: 36.581494307205766),
            MapPoint(longitude: 127.32177688022196, latitude: 36.58142010061243),
            MapPoint(longitude: 127.32159783779174, latitude: 36.58137155982673),
            MapPoint(longitude: 127.32149145640194, latitude: 36.581309521278094),
            MapPoint(longitude: 127.3216283110897, latitude: 36.581069354885386),
            MapPoint(longitude: 127.32492488890603, latitude: 36.58009508817309),
            MapPoint(longitude: 127.32503258811488, latitude: 36.579915938565144),
            MapPoint(longitude: 127.32502765818164, latitude: 36.579588549165955),
            MapPoint(longitude: 127.32475727815836, latitude: 36.579022822135805),
            MapPoint(longitude: 127.32531050395207, latitude: 36.57837084280806),
            MapPoint(longitude: 127.32538481267486, latitude: 36.57811842189787),
            MapPoint(longitude: 127.3254359215498, latitude: 36.57782247653914),
            MapPoint(longitude: 127.3254549248763, latitude: 36.57771238013681),
            MapPoint(longitude: 127.32573981497552, latitude: 36.577526403721244),
            MapPoint(longitude: 127.32779035974866, latitude: 36.57589447536298),
            MapPoint(longitude: 127.32788265003703, latitude: 36.57583716261832),
            MapPoint(longitude: 127.32790905889074, latitude: 36.5757729205331),
            MapPoint(longitude: 127.32805098940516, latitude: 36.57577673759555),
            MapPoint(longitude: 127.3281758402883, latitude: 36.57574150644202),
            MapPoint(longitude: 127.32881832948651, latitude: 36.57556636316261),
            MapPoint(longitude: 127.32908280516796, latitude: 36.57535742216015),
            MapPoint(longitude: 127.32942389524071, latitude: 36.57531337451181),
            MapPoint(longitude: 127.32970417274994, latitude: 36.57498935412286),
            MapPoint(longitude: 127.3344462746174, latitude: 36.57160151508699),
            MapPoint(longitude: 127.3349901217512, latitude: 36.571431247627494),
            MapPoint(longitude: 127.33573602887667, latitude: 36.570702852165844),
            MapPoint(longitude: 127.33576934132576, latitude: 36.5706065082213),
            MapPoint(longitude: 127.33617096660163, latitude: 36.57025631710134),
            MapPoint(longitude: 127.33655020881913, latitude: 36.569986073887144),
            MapPoint(longitude: 127.33620739544183, latitude: 36.56952049958285),
            MapPoint(longitude: 127.33606719895977, latitude: 36.56933078804634),
            MapPoint(longitude: 127.33575233431071, latitude: 36.56890475763566),
            MapPoint(longitude: 127.33515454924374, latitude: 36.568096137968155),
            MapPoint(longitude: 127.33546734029163, latitude: 36.56726329843188),
            MapPoint(longitude: 127.33559099044388, latitude: 36.56710112640649),
            MapPoint(longitude: 127.33584832797901, latitude: 36.56667752799316),
            MapPoint(longitude: 127.33642085438704, latitude: 36.565554012778996),
            MapPoint(longitude: 127.336584401099, latitude: 36.56534770780269),
            MapPoint(longitude: 127.33662673183058, latitude: 36.56515687250125),
            MapPoint(longitude: 127.33682386060448, latitude: 36.56427923203463),
            MapPoint(longitude: 127.33684255298114, latitude: 36.56427749450982),
            MapPoint(longitude: 127.33685970559493, latitude: 36.56424247321924),
            MapPoint(longitude: 127.33688132076517, latitude: 36.56419839168468),
            MapPoint(longitude: 127.34080478039098, latitude: 36.56364152551656),
            MapPoint(longitude: 127.34086982579575, latitude: 36.56363593369186),
            MapPoint(longitude: 127.34243191690224, latitude: 36.56372112268328),
            MapPoint(longitude: 127.34324334759147, latitude: 36.56462472183839),
            MapPoint(longitude: 127.34444211247006, latitude: 36.56435856255148),
            MapPoint(longitude: 127.34446478563817, latitude: 36.56432467521305),
            MapPoint(longitude: 127.34348871364591, latitude: 36.56441327636665),
            MapPoint(longitude: 127.34339377058384, latitude: 36.56439283337752),
            MapPoint(longitude: 127.34452911030007, latitude: 36.56401482451396),
            MapPoint(longitude: 127.34738548273008, latitude: 36.564087098689406),
            MapPoint(longitude: 127.34784963993853, latitude: 36.56385581697319),
            MapPoint(longitude: 127.36825983291152, latitude: 36.566196532635615),
            MapPoint(longitude: 127.40182466649642, latitude: 36.54124048495118),
            MapPoint(longitude: 127.40982635082797, latitude: 36.495320806621656),
            MapPoint(longitude: 127.40278189051706, latitude: 36.493414713499995),
            MapPoint(longitude: 127.40029554490653, latitude: 36.49344405572545),
            MapPoint(longitude: 127.3969998205258, latitude: 36.49234724550459),
            MapPoint(longitude: 127.39612424170942, latitude: 36.49172477764016),
            MapPoint(longitude: 127.39612055279709, latitude: 36.49172147304118),
            MapPoint(longitude: 127.39575988535204, latitude: 36.49195602619904),
            MapPoint(longitude: 127.38626339999793, latitude: 36.498985556577466),
            MapPoint(longitude: 127.38538373894964, latitude: 36.499444883432616),
            MapPoint(longitude: 127.38385497104343, latitude: 36.500230690026456),
            MapPoint(longitude: 127.38230967353526, latitude: 36.49992444824916),
            MapPoint(longitude: 127.38096688868224, latitude: 36.499660645040414),
            MapPoint(longitude: 127.38033654837668, latitude: 36.49953929874922),
            MapPoint(longitude: 127.38008138312885, latitude: 36.499215976257155),
            MapPoint(longitude: 127.35579857644919, latitude: 36.450273038129),
            MapPoint(longitude: 127.3263167270464, latitude: 36.422208976417835),
            MapPoint(longitude: 127.29425168764308, latitude: 36.42219502183513),
            MapPoint(longitude: 127.29426961581308, latitude: 36.421915039124464),
            MapPoint(longitude: 127.28212428234082, latitude: 36.414603964631645),
            MapPoint(longitude: 127.25790805131376, latitude: 36.40823236399692),
            MapPoint(longitude: 127.20138964906599, latitude: 36.44197527604719),
            MapPoint(longitude: 127.20473351147956, latitude: 36.45929024006822),
            MapPoint(longitude: 127.17346586866955, latitude: 36.499206669441534),
            MapPoint(longitude: 127.17266844902414, latitude: 36.536143615637876),
            MapPoint(longitude: 127.19378772255222, latitude: 36.564812513911036),
            MapPoint(longitude: 127.17865507176774, latitude: 36.59668359063944),
            MapPoint(longitude: 127.1786181246923, latitude: 36.59671264216109),
            MapPoint(longitude: 127.15547820292068, latitude: 36.606702898566276),
            MapPoint(longitude: 127.15485840345418, latitude: 36.6642746537941),
            MapPoint(longitude: 127.13437853561463, latitude: 36.7067919896922),
            MapPoint(longitude: 127.15964389368695, latitude: 36.732843948327705),
            MapPoint(longitude: 127.20793603234716, latitude: 36.71918904581354)
            
        ]
        
        
        
        if pointInPolygon(point: (testPoint.wgsCoord.latitude, testPoint.wgsCoord.longitude), vs: dimPolygon.map { ($0.wgsCoord.latitude, $0.wgsCoord.longitude) })
        {
            print("영역내", testPoint.wgsCoord.latitude, testPoint.wgsCoord.longitude)
        } else {
            print("영역 외", testPoint.wgsCoord.latitude, testPoint.wgsCoord.longitude)
        }
    }
    
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
        
        let layer = manager.addShapeLayer(layerID: "shape", zOrder: 10001)
        let options = MapPolygonShapeOptions(shapeID: "mapPolygonShape", styleID: "ShapeStyle", zOrder: 1)
        let polygon = MapPolygon(exteriorRing: [
            MapPoint(longitude: 127.10656, latitude: 37.40303),
            MapPoint(longitude: 127.10655, latitude: 37.40301),
            MapPoint(longitude: 127.10660, latitude: 37.40247),
            MapPoint(longitude: 127.10938, latitude: 37.40249),
            MapPoint(longitude: 127.10946, latitude: 37.40253),
            MapPoint(longitude: 127.10945, latitude: 37.40298),
            MapPoint(longitude: 127.10656, latitude: 37.40303)
        ], hole: nil, styleIndex: 0)
        options.polygons.append(polygon)
        
        let shape = layer?.addMapPolygonShape(options)
        shape?.show()
        
        let cameraUpdate = CameraUpdate.make(area: AreaRect(points: polygon.exteriorRing))
        mapView.moveCamera(cameraUpdate)
    }
    
    func createDimPolygonSet() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        mapView.dimScreen.isEnabled = true
        let dimScreen: DimScreen = mapView.dimScreen
        
        let shapeStyle = PolygonStyle(styles: [
            PerLevelPolygonStyle(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0), strokeWidth: 3, strokeColor: UIColor.red, level: 0),
            PerLevelPolygonStyle(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0), strokeWidth: 3, strokeColor: UIColor.red, level: 15)
        ])
        let shapeStyleSet = PolygonStyleSet(styleSetID: "shapeLevelStyle", styles: [shapeStyle])
        
        dimScreen.addPolygonStyleSet(shapeStyleSet)
    }
    
    func createDimScreenShape() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let dimScreen: DimScreen = mapView.dimScreen
        
        let options = MapPolygonShapeOptions(shapeID: "shape1", styleID: "shapeLevelStyle", zOrder: 1)
        let dimPolygon = [
            MapPoint(longitude: 127.10656, latitude: 37.40303),
            MapPoint(longitude: 127.10655, latitude: 37.40301),
            MapPoint(longitude: 127.10660, latitude: 37.40247),
            MapPoint(longitude: 127.10938, latitude: 37.40249),
            MapPoint(longitude: 127.10946, latitude: 37.40253),
            MapPoint(longitude: 127.10945, latitude: 37.40298)
        ]
        
        let dim = MapPolygon(exteriorRing: dimPolygon, hole: nil, styleIndex: 0)
        options.polygons.append(dim)
        
        let shape = dimScreen.addHighlightMapPolygonShape(options)
        shape?.show()
    }
    
    func pointInPolygon(point: (Double, Double), vs: [(Double, Double)]) -> Bool {
        let (x, y) = point
        var wn = 0
        
        for i in 0..<vs.count {
            let j = (i == 0) ? vs.count - 1 : i - 1
            let (xi, yi) = vs[i]
            let (xj, yj) = vs[j]
            
            if yj <= y {
                if yi > y {
                    if isLeft(P0: (xj, yj), P1: (xi, yi), P2: (x, y)) > 0 {
                        wn += 1
                    }
                }
            } else {
                if yi <= y {
                    if isLeft(P0: (xj, yj), P1: (xi, yi), P2: (x, y)) < 0 {
                        wn -= 1
                    }
                }
            }
        }
        return wn != 0
    }
    
    func isLeft(P0: (Double, Double), P1: (Double, Double), P2: (Double, Double)) -> Double {
        return (P1.0 - P0.0) * (P2.1 - P0.1) - (P2.0 - P0.0) * (P1.1 - P0.1)
    }
    
    
    
}
