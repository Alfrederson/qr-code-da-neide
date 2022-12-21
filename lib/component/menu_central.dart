import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'banner_anuncio.dart';

Widget menuCentral( List<Widget> children) =>
  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      constraints: const BoxConstraints(
                            minWidth: double.maxFinite
                    ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children
                )
              )
            ),
            const BannerAnuncio(tamanho : AdSize.largeBanner),
          ]
          ),
  );