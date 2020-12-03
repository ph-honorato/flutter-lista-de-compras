/*
  Classe criada para tarefas
 */

class ClasseCompra {

  int id;
  String descricao;
  String imagem;
  String video;
  String audio;

  ClasseCompra(int id, String descricao, String imagem, String video, String audio){
    this.id = id;
    this.descricao = descricao;
    this.imagem = imagem;
  }

  int dispId(){
    return id;
  }

  String dispDescricao(){
    return descricao;
  }

  String dispImagem(){
    return imagem;
  }

}