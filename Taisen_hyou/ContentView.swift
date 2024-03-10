//
//  ContentView.swift
//  Taisen_hyou
//
//  Created by User on 2024/03/07.
//

import SwiftUI
import Foundation
import GameplayKit

let number_Game: Int = 30

var Cells = [String](repeating: "", count: number_Game)

struct ContentView: View {
    
    @State private var multiSelection = Set<UUID>()
    @State var CortnumberValue: Int = 1
    @State var numberValue: Int = 5


    @State private var isPresented: Bool = false
    
    var body: some View {
        
        Text("組み合わせ表")
            .font(.largeTitle)
            .fontWeight(.ultraLight)
            .multilineTextAlignment(.center)
            
            
        Form {
            Stepper("コート数        \(CortnumberValue)", value: $CortnumberValue, in: 1...4)
                .frame(width: 250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0)
                
            Stepper("人数              \(numberValue)", value: $numberValue, in: 4...40)
                .frame(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                
        }
        .frame(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/320.0/*@END_MENU_TOKEN@*/)
            
        Button(action: {
            Ransu(Cort_num : CortnumberValue, Menber_num : numberValue)
            isPresented = true //trueにしないと画面遷移されない
        }) {
            Text("実行")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/)
        }
        .fullScreenCover(isPresented: $isPresented) { //フルスクリーンの画面遷移
            NextView()
        }
    }
        
    
}

struct NextView: View {
        
    @State private var selectedFruit: UUID?
    @State private var isPresented: Bool = false
    @State private var selection: Set<String> = Set()
    @Environment(\.editMode) var editMode
    
    var body: some View {
        
        Button(action: {
            isPresented = true //trueにしないと画面遷移されない
        }) {
            Text("設定画面へ戻る")
            //.multilineTextAlignment(.)
        }
        .fullScreenCover(isPresented: $isPresented) { //フルスクリーンの画面遷移
            ContentView()
        }
        
        List(Cells, id: \.self , selection: $selection) { index in
            //ForEach(0 ..< 50) { index in
                Text(index)
            //}
        }
        .onAppear {
            editMode?.wrappedValue = .active
        }
    }
}

struct CustomRandomGenerator: RandomNumberGenerator {
    func next() -> UInt64 {
        // ここで独自の乱数生成ロジックを実装
        return UInt64.random(in: 0..<UInt64.max)
    }
}

func Ransu(Cort_num : Int, Menber_num : Int)
{
//    var Menber_num = 9
//    @State var Cort_num = 2
    @State var Game_num = number_Game

    var iCol = 0
    var _iCnt : Int
    var iTmp : Int
    var sNum = [String](repeating: "", count: Cort_num * 4) //: [String] = []
    var bChk = [Bool](repeating: true, count: Menber_num + 1) //: [Bool] = []
    var bChk2 = [Bool](repeating: true, count: Menber_num + 1) //:  [Bool] = []
    var bFull : Bool
    var iCourt : Int
    var temp1 : Double
    
    if (Cort_num * 4 > Int(Menber_num)) {
        iCourt = Int((Double(Menber_num) / 4 - 0.5).rounded())
    } else {
        iCourt = Cort_num;
    }
            
    for iCnt in stride(from: 0, to: Int(Menber_num), by: 1)
    {
        bChk[iCnt] = true;
        bChk2[iCnt] = true;
    }
    
    //let now = Date()
    //let calendar = Calendar.current
    //var _second_time = calendar.component(.second, from: now)

    for __num in stride(from : 0, to: Game_num, by: 1)
    {
        _iCnt = 0;
        while (!(_iCnt == iCourt * 4)) {
            let temp0 = Double.random(in: 0.01...0.99)
            temp1 = temp0 * Double(Menber_num) + 0.5
            //let distribution = GKGaussianDistribution(randomSource: GKRandomSource.sharedRandom(), lowestValue: 0, highestValue: 100)
            //let randomNumber = distribution.nextInt()
            //temp1 = (Double(randomNumber) * Double(Menber_num)) / 100 + 0.5

            iTmp = Int(temp1.rounded())
            if (bChk[iTmp] && bChk2[iTmp]) {
                sNum[_iCnt] = "[" + String(iTmp) + "]"
                _iCnt = _iCnt + 1
                bChk[iTmp] = false
                bChk2[iTmp] = false
                bFull = false
                    
                for _iCnt2 in stride(from: 1 ,to: Int(Menber_num), by: 1)
                {
                    bFull = bFull || bChk[_iCnt2]
                }
                    
                if (bFull == false) {
                        
                    for _iCnt7 in stride(from: 1, to: Int(Menber_num + 1), by: 1)
                    {
                        bChk[_iCnt7] = true
                    }
                }
            }
        }
        
        Cells[iCol] = sNum[0]
        
        for _iCnt6 in stride(from: 1, to: iCourt * 4, by: 1 )
        {
            switch (_iCnt6 % 4) {
            case 0:
                Cells[iCol] = Cells[iCol] + "  /  " + sNum[_iCnt6]
                break
            case 2:
                Cells[iCol] = Cells[iCol] + "-" + sNum[_iCnt6]
                break
            default:
                Cells[iCol] = Cells[iCol] + sNum[_iCnt6]
                break
            }
        }
        
        for _iCnt8 in stride(from: 1, to: Int(Menber_num + 1), by: 1)
        {
            bChk2[_iCnt8] = true
        }
        iCol = iCol + 1
    }
}
#Preview {
    ContentView()
}
