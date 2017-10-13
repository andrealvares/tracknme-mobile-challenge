# Desafio Mobile

O desafio consiste em criar um app com as seguintes características:

# Task 1 - Desenhar e movimentar personagem no mapa

Implementar um app cuja tela principal apresenta um mapa (google maps) e uma personagem humanoide posicionado nas coordenadas GPS do telefone. Link para a personagem.

A personagem deve passar impressão de tridimensionalidade e deve andar nas posições das coordenadas providas nesse arquivo de response JSON (link). Após a personagem concluir todo o trajeto do arquivo de response, o usuário deve ser capaz de direcionar a personagem para um novo ponto. Esse novo ponto pode ser um click no mapa qualquer outra interface de entrada de dados que julgar válida. 

# Task 2 - Listar o histórico do trajeto

Mostrar numa tela, todos o histórico do trajeto feito pela personagem, tantos o trajeto provenientes do arquivo JSON como os novos movimentos adicionados pelo usuário, por ordem decrescente de data/hora. A listagem deve conter os atributos: dateTime e Endereço legível ao usuário (por ex.: Rua Tal e tal, São Paulo - SP).

O aplicativo deve permitir o uso offline. Nesse caso o usuário poderá visualizar os dados existentes na base local até o momento que estava com conectividade.

