import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class Conversor {

  Future<String> converterImagemString(PickedFile imagem) async{

    List<int> imageBytes = await imagem.readAsBytes();
    String base64Img = base64Encode(imageBytes);

    //print("CONVERSOR");
    //print(base64Img);

    return base64Img;
  }

  Image converterStringImagem( String string) {

    //print("RECONVERTER");

    Image imagem = Image.memory( base64Decode(string) );

    return imagem;
  }

}