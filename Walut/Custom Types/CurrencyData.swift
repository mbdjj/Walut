//
//  CurrencyData.swift
//  Walut
//
//  Created by Marcin Bartminski on 08/10/2022.
//

import Foundation

struct CurrencyData: Decodable {
    
    let baseCode: String
    let timeNextUpdateUnix: Int
    let rates: Rates
    
}

//All the currencies offered by API
struct Rates: Decodable {
    
    //let AED: Double
    //let AFN: Double
    //let ALL: Double
    //let AMD: Double
    //let ANG: Double
    //let AOA: Double
    //let ARS: Double
    let AUD: Double?
    //let AWG: Double
    //let AZN: Double
    //let BAM: Double
    //let BBD: Double
    //let BDT: Double
    let BGN: Double?
    //let BHD: Double
    //let BIF: Double
    //let BMD: Double
    //let BND: Double
    //let BOB: Double
    let BRL: Double?
    //let BSD: Double
    //let BTC: Double
    //let BTN: Double
    //let BWP: Double
    //let BYN: Double
    //let BZD: Double
    let CAD: Double?
    //let CDF: Double
    let CHF: Double?
    //let CLF: Double
    //let CLP: Double
    //let CNH: Double
    let CNY: Double?
    //let COP: Double
    //let CRC: Double
    //let CUC: Double
    //let CUP: Double
    //let CVE: Double
    let CZK: Double?
    //let DJF: Double
    let DKK: Double?
    //let DOP: Double
    //let DZD: Double
    //let EGP: Double
    //let ERN: Double
    //let ETB: Double
    let EUR: Double?
    //let FJD: Double
    //let FKP: Double
    let GBP: Double?
    //let GEL: Double
    //let GGP: Double
    //let GHS: Double
    //let GIP: Double
    //let GMD: Double
    //let GNF: Double
    //let GTQ: Double
    //let GYD: Double
    let HKD: Double?
    //let HNL: Double
    let HRK: Double?
    //let HTG: Double
    let HUF: Double?
    let IDR: Double?
    let ILS: Double?
    //let IMP: Double
    let INR: Double?
    //let IQD: Double
    //let IRR: Double
    //let ISK: Double
    //let JEP: Double
    //let JMD: Double
    //let JOD: Double
    let JPY: Double?
    //let KES: Double
    //let KGS: Double
    //let KHR: Double
    //let KMF: Double
    //let KPW: Double
    let KRW: Double?
    //let KWD: Double
    //let KYD: Double
    //let KZT: Double
    //let LAK: Double
    //let LBP: Double
    //let LKR: Double
    //let LRD: Double
    //let LSL: Double
    //let LYD: Double
    //let MAD: Double
    //let MDL: Double
    //let MGA: Double
    //let MKD: Double
    //let MMK: Double
    //let MNT: Double
    //let MOP: Double
    //let MRO: Double
    //let MRU: Double
    //let MUR: Double
    //let MVR: Double
    //let MWK: Double
    let MXN: Double?
    let MYR: Double?
    //let MZN: Double
    //let NAD: Double
    //let NGN: Double
    //let NIO: Double
    let NOK: Double?
    //let NPR: Double
    let NZD: Double?
    //let OMR: Double
    //let PAB: Double
    //let PEN: Double
    //let PGK: Double
    let PHP: Double?
    //let PKR: Double
    let PLN: Double?
    //let PYG: Double
    //let QAR: Double
    let RON: Double?
    //let RSD: Double
    let RUB: Double?
    //let RWF: Double
    //let SAR: Double
    //let SBD: Double
    //let SCR: Double
    //let SDG: Double
    let SEK: Double?
    let SGD: Double?
    //let SHP: Double
    //let SLL: Double
    //let SOS: Double
    //let SRD: Double
    //let SSP: Double
    //let STD: Double
    //let STN: Double
    //let SVC: Double
    //let SYP: Double
    //let SZL: Double
    let THB: Double?
    //let TJS: Double
    //let TMT: Double
    //let TND: Double
    //let TOP: Double
    let TRY: Double?
    //let TTD: Double
    //let TWD: Double
    //let TZS: Double
    let UAH: Double?
    //let UGX: Double
    let USD: Double?
    //let UYU: Double
    //let UZS: Double
    //let VES: Double
    //let VND: Double
    //let VUV: Double
    //let WST: Double
    //let XAF: Double
    //let XAG: Double
    //let XAU: Double
    //let XCD: Double
    //let XDR: Double
    //let XOF: Double
    //let XPD: Double
    //let XPF: Double
    //let XPT: Double
    //let YER: Double
    let ZAR: Double?
    //let ZMW: Double
    //let ZWL: Double
    
    var ratesDictionary: [String: Double?] {
        let dict = [
            "AUD": AUD,
            "BRL": BRL,
            "BGN": BGN,
            "CAD": CAD,
            "CNY": CNY,
            "HRK": HRK,
            "CZK": CZK,
            "DKK": DKK,
            "EUR": EUR,
            "HKD": HKD,
            "HUF": HUF,
            "INR": INR,
            "IDR": IDR,
            "ILS": ILS,
            "JPY": JPY,
            "MYR": MYR,
            "MXN": MXN,
            "RON": RON,
            "NZD": NZD,
            "NOK": NOK,
            "PHP": PHP,
            "PLN": PLN,
            "GBP": GBP,
            "RUB": RUB,
            "SGD": SGD,
            "ZAR": ZAR,
            "KRW": KRW,
            "SEK": SEK,
            "CHF": CHF,
            "THB": THB,
            "TRY": TRY,
            "USD": USD,
            "UAH": UAH
        ]
        
        return dict
    }
    
    //Method to make it easier to grab rate of specific currency rate.
    func getRate(of code: String) -> Double {
        return ratesDictionary[code]! ?? 0.0
    }
    
}
