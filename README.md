![TrackNMe](https://www.tracknme.com.br/app/images/logo-tracknme.png)


# Desafio Mobile

O desafio consiste em criar um app com as seguintes características:

# Task 1 - Desenhar e movimentar personagem no mapa

Implementar um app cuja tela principal apresenta um mapa (google maps) e uma personagem humanoide posicionado nas coordenadas GPS do telefone. [Link para a personagem](https://github.com/andrealvares/tracknme-mobile-challenge/blob/master/assets/sprites.png).

A personagem deve passar impressão de tridimensionalidade e deve andar nas posições das coordenadas providas nesse [arquivo de response JSON](https://github.com/andrealvares/tracknme-mobile-challenge/blob/master/assets/posicoes.json). Após a personagem concluir todo o trajeto do arquivo de response, o usuário deve ser capaz de direcionar a personagem para um novo ponto. Esse novo ponto pode ser um click no mapa qualquer outra interface de entrada de dados que julgar válida. 

A nova posição deve ser salva localmente (usando o Realm) e sua aplicação deve realizar um `POST` com os seguintes atributos:

``` json
{
    	"dateTime": "2017-10-12T21:34:15",
	"latitude": -23.962676666666667,
	"longitude": -46.3884785
}
```
Aconselhamos que use o [Apiary](https://apiary.io) como API nessa etapa.

# Task 2 - Listar o histórico do trajeto

Mostrar numa tela, todos o histórico do trajeto feito pela personagem, tantos o trajeto provenientes do arquivo JSON como os novos movimentos adicionados pelo usuário, por ordem decrescente de data/hora. A listagem deve conter os atributos: dateTime e Endereço legível ao usuário (por ex.: Rua Tal e tal, São Paulo - SP).

O aplicativo deve permitir o uso offline. Nesse caso o usuário poderá visualizar os dados existentes na base local até o momento que estava com conectividade.

---
#### LICENSE
```
MIT License

Copyright (c) 2016 Stone Pagamentos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
