import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
    Funções de banco de dados
 */

class Banco {

  String nomeBanco = "bancoCompras.bd";
  String nomeTabela = "compra";

  recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, this.nomeBanco);

    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente){
          String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, descricao VARCHAR, imagem VARCHAR, video VARCHAR, audio VARCHAR)";
          db.execute(sql);
        }
    );

    //bd.execute("CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, descricao VARCHAR, imagem VARCHAR, video VARCHAR, audio VARCHAR)");
    //bd.execute("DELETE FROM $nomeTabela");
    //print("aberto: " + bd.isOpen.toString() );

    return bd;
  }


  listarDados() async {

    Database bd = await recuperarBancoDados();
    String sql = "SELECT * FROM $nomeTabela";

    List listaCompras = await bd.rawQuery(sql); //conseguimos escrever a query que quisermos

    return listaCompras;
  }


  salvarDados(String descricao, String imagem, String video, String audio) async {

    Database bd = await recuperarBancoDados();
    Map<String, dynamic> dadosCompra = {
      "descricao" : descricao,
      "imagem": imagem,
      "video": video,
      "audio": audio
    };
    int id = await bd.insert(nomeTabela, dadosCompra);

    print("Item Salvo: $id $descricao $imagem" );
  }


  excluirDado( int id ) async{
    Database bd = await recuperarBancoDados();
    int retorno = await bd.delete(nomeTabela, where: "id = $id");

    print("Item Excluídos " + retorno.toString());
  }


  atualizarDado( int id, String descricao, String imagem, String video, String audio ) async{

    Database bd = await recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "descricao" : descricao,
      "imagem": imagem
    };

    int retorno = await bd.update( nomeTabela, dadosUsuario, where: "id = $id" );

    print("Item Atualizado: "+ retorno.toString());
  }


}