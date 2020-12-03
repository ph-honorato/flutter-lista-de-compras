import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../classes/classeCompra.dart' as cc;
import '../database/dbListaDeCompras.dart' as db;
import '../players/audio.dart';
import '../classes/conversorImagem.dart' as conversor;

class PaginaListaDeCompras extends StatefulWidget {
  @override
  _PaginaListaDeComprasState createState() => _PaginaListaDeComprasState();
}

/*
  Método Principal
 */

class _PaginaListaDeComprasState extends State<PaginaListaDeCompras> {

  TextEditingController _controller = TextEditingController();
  List<cc.ClasseCompra> _listaDeCompras = [];
  Audio _audioLocal = new Audio();
  VideoPlayerController _videoController;
  final ImagePicker _picker = ImagePicker();

  bool _showFoto = false;
  bool _showVideo = false;
  bool _showAudio = false;
  var _colorFoto = Colors.grey;
  var _colorVideo = Colors.grey;
  var _colorAudio = Colors.grey;
  var _playPause = Icons.play_arrow;


  @override
  void initState(){
    super.initState();
    _atualizarCompras();
  }

  /*
    Atualizar Compras
  */

  _atualizarCompras() async{

    List listaCompras = await db.Banco().listarDados();

    setState(() {

      _listaDeCompras = [];

      for(var compra in listaCompras){
        _listaDeCompras.add( new cc.ClasseCompra(compra['id'], compra['descricao'], compra['imagem'], compra['video'], compra['audio'] ));
      }

    });

  }


  /*
    Pega imagem na galeria
  */

  Future _addImage(int id, String descricao) async {
    try {

      final PickedFile imagem = await _picker.getImage(source: ImageSource.gallery);
      String sc = await conversor.Conversor().converterImagemString(imagem);
      await db.Banco().atualizarDado(id, descricao, sc, "", "");

    } catch(e) {

      print("ERRO ENCONTRADO: $e");
    }
  }


  /*
    Dar play em um Vídeo
  */

  _playVideo(){

    _videoController = VideoPlayerController.asset(
        "assets/videos/exemplo.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //setState(() {});
        _videoController.play();
      });

  }

  /*
   Chama a caixa de texto para fazer uma inserção ou atualização
 */


  _abrirCaixaDeTexto( BuildContext context, int id, String imagem ){

    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Adicionar compra: "),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    TextField(
                      decoration: InputDecoration(
                          labelText: "Digite sua compra"
                      ),
                      controller: _controller,
                    ),

                    SizedBox(height: 20),

                  ],
                ),
                actions: <Widget>[

                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")
                  ),

                  FlatButton(
                      onPressed: () {

                        if (id == null)
                          db.Banco().salvarDados(this._controller.text, "", "", "");
                        else
                          db.Banco().atualizarDado(id, this._controller.text, imagem, "", "");

                        _atualizarCompras();
                        _controller.text = "";
                        Navigator.pop(context);
                      },
                      child: Text("Salvar")
                  ),

                ],

              );
            },
          );

        }
    );
  }


  /*
     Abre caixa com opções de mídia
  */

  _abrirCaixaDeMidia( BuildContext context, cc.ClasseCompra compra){

    showDialog(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return  AlertDialog(
                title: Text(compra.dispDescricao()),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Row(
                      children: <Widget>[

                        Expanded(
                            flex: 3,
                            child: IconButton(
                                icon:Icon(Icons.photo, color: _colorFoto) ,
                                onPressed: (){

                                  setState(() {

                                    if(_showFoto == false){
                                      _showVideo = false;
                                      _showFoto = true;
                                      _colorFoto = Colors.blue;
                                      _colorVideo = Colors.grey;

                                    } else {
                                      _showFoto = false;
                                      _colorFoto = Colors.grey;
                                    }

                                  });

                                  _atualizarCompras();

                                }
                            )
                        ),  //Imagem

                        Expanded(
                            flex: 4,
                            child: IconButton(
                                icon:Icon(Icons.video_library, color: _colorVideo) ,
                                onPressed: (){

                                  setState(() {

                                    if(_showVideo == false){
                                      _showVideo = true;
                                      _colorVideo = Colors.blue;

                                      _showFoto = false;
                                      _colorFoto = Colors.grey;

                                      _playVideo();

                                    } else {
                                      _showVideo = false;
                                      _colorVideo = Colors.grey;
                                    }

                                  });

                                }
                            )
                        ), //Video

                        Expanded(
                            flex: 3,
                            child:  IconButton(
                                icon: Icon(_playPause, color: _colorAudio) ,
                                onPressed: (){

                                  setState(() {

                                    if(_showAudio == false){

                                      _showAudio = true;
                                      _playPause = Icons.pause;
                                      _colorAudio = Colors.blue;

                                      _audioLocal.tocar("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3");

                                    } else {

                                      _showAudio = false;
                                      _playPause = Icons.play_arrow;
                                      _colorAudio = Colors.grey;

                                      _audioLocal.pausar();

                                    }
                                });
                              }
                          ),
                        ), //Audio

                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      children: <Widget>[

                        Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) => _showFoto == true,
                          widgetBuilder: (BuildContext context) =>

                              Container(

                                child: compra.dispImagem() == "" ?

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: ((){

                                        _addImage(compra.dispId(), compra.dispDescricao());
                                        _atualizarCompras();

                                      }),
                                    ),
                                    Center(child: Text("Adicione uma imagem")),

                                  ]
                                )

                                  :

                                Expanded(
                                    flex: 10,
                                    child: conversor.Conversor().converterStringImagem( compra.dispImagem())
                                ),

                              ),

                          fallbackBuilder: (BuildContext context) => SizedBox(height: 0),
                        ), //Imagem

                        Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) => _showVideo == true,
                          widgetBuilder: (BuildContext context) =>

                              Expanded(
                                  flex: 10,
                                  child: AspectRatio(
                                  aspectRatio: _videoController.value.aspectRatio,
                                  child: VideoPlayer(_videoController),
                                )
                              ),
                          fallbackBuilder: (BuildContext context) => SizedBox(height: 0),
                        ),

                      ],
                    ),

                  ],
                ),



                actions: <Widget>[
                  FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")
                  ),
                ],

              );
            },
          );

        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData( color: Colors.white ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          elevation: 6,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: (){
            _atualizarCompras();
            _abrirCaixaDeTexto(context, null, null);

          }
      ),

      body: Column(
          children: <Widget>[

            Expanded(
             child: ListView.builder(
               itemCount: _listaDeCompras.length,
               itemBuilder: (context, index){
                 return Card(
                    color: Colors.white,
                    child: new InkWell(

                      onTap: (){
                       _controller.text = _listaDeCompras[index].dispDescricao();
                       _abrirCaixaDeTexto(context, _listaDeCompras[index].dispId(), _listaDeCompras[index].dispImagem() );
                      },

                       child: Padding(
                         padding: EdgeInsets.all(12.0),
                         child: Row (

                           children: <Widget>[

                             Expanded(
                               flex: 8,
                               child: Text( _listaDeCompras[index].dispDescricao() ),
                             ),

                             Expanded(
                                 flex: 1,
                                 child: IconButton(
                                     icon:Icon(Icons.add, color: Colors.blue) ,
                                     onPressed: (){
                                       _abrirCaixaDeMidia(context, _listaDeCompras[index]  );
                                     }
                                 )
                             ),

                             Expanded(
                                 flex: 1,
                                 child: IconButton(
                                     icon:Icon(Icons.delete, color: Colors.red) ,
                                     onPressed: (){
                                       db.Banco().excluirDado( _listaDeCompras[index].dispId() );
                                       _atualizarCompras();
                                     }
                                 )
                             ),

                           ],

                         ),
                       )

                   )

                );
              }

              ),
           ),
          ],
        ),
    );
  }
}
