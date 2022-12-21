import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class BannerAnuncio extends StatefulWidget{
  final AdSize tamanho;
  final double? largura;
  final double? altura;

  const BannerAnuncio({super.key , this.tamanho = AdSize.largeBanner, this.largura, this.altura});

  @override
  State<StatefulWidget> createState() => _BannerAnuncioState();
}

class _BannerAnuncioState extends State<BannerAnuncio>{
  static var adUnitID = "";


  AdManagerBannerAd? _ad;

  // vou escolher o tamanho com base no valor do 
  // enum e estou 100% nem aí
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.tamanho.height > 0 ? widget.tamanho.height * 1.0 : widget.altura,
      width: widget.tamanho.width > 0 ?  widget.tamanho.width * 1.0 : widget.largura,
      child: _ad != null ? 
              AdWidget(ad : _ad!) : 
              SizedBox(height: widget.tamanho.height > 0 ? widget.tamanho.height * 1.0 : widget.altura)
    );
  }

  @override
  void dispose(){
    super.dispose();
    _ad?.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(adUnitID.isEmpty){
      log("Obtendo AD_UNIT_ID");
      adUnitID = FlutterConfig.get("ADMOB_AD_UNIT_ID");
      log("Obtido: $adUnitID");
    }
    _ad = AdManagerBannerAd(
      sizes: [widget.tamanho],
      adUnitId: 'ca-app-pub-9754268803581055/9356788332',
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad){
          log("$_ad carregado.");
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error){
          log("$_ad não carregou: $error");
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log("$_ad aberto"),
        onAdClosed: (Ad ad) => log("$_ad fechado")
      )
    )..load();
  }

}