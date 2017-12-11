![TrackNMe](https://www.tracknme.com.br/app/images/logo-tracknme.png)


# Desafio Mobile

O candidato deve dar **fork** neste repositório e após o termino do desenvolvimento, realizar um **pull request** e avisar por **email** para análise do time.

O desafio consiste em criar um app com as seguintes características:

# Task 1 - Desenhar e movimentar marcador no mapa

- Implementar um app cuja tela principal apresenta um mapa (Android google maps/ IOS mapkit) 
- Consumir de uma API Rest uma lista de posições (ex: [arquivo de response JSON](https://github.com/andrealvares/tracknme-mobile-challenge/blob/master/assets/posicoes.json)) (Aconselhamos que use o [Apiary](https://apiary.io) como API nessa etapa ou outra semelhante).
- A resposta da API deve ser salva em banco local (Android Realm / IOS CoreData) para futuras consultas sem a necessidade de nova consulta na API Rest
- O marcador no mapa deve se deslocar por essas posições formando um trajeto
- Após o término do trajeto das posições recebidas, deve ser possível tocar no mapa e ir para uma nova posição
- A nova posição deve ser salva localmente (usando o Realm/CoreData) e sua aplicação deve realizar um `POST` com os seguintes atributos:

``` json
{
    "dateTime": "2017-10-12T21:34:15",
    "latitude": -23.9626766,
    "longitude": -46.3884785
}
```

Diferencial (Não obrigatório):
- Utilizar um marcador personalizado de um personagem humanoide [Link para a personagem](https://github.com/andrealvares/tracknme-mobile-challenge/blob/master/assets/sprites.png).


# Task 2 - Listar o histórico do trajeto

Em uma nova tela chamada histórico, mostrar no mapa todo o trajeto feito pela personagem, tanto o trajeto proveniente do arquivo JSON como os novos movimentos adicionados pelo usuário por ordem decrescente de data/hora. 

Ao tocar em um ponto do trajeto, mostrar as informações de dateTime e endereço legível ao usuário (por ex.: 01/12/2017 - Rua Tal e tal, São Paulo - SP) referentes aquele ponto. Essa informação pode ser mostrada em um InfoWindow ou Modal.

O aplicativo deve permitir o uso offline. Nesse caso o usuário poderá visualizar os dados existentes na base local até o momento que estava com conectividade.


---
#### LICENSE
```
MIT License

Copyright (c) 2017 TrackNMe

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
