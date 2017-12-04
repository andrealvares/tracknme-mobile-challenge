#Desafio TracknMe  
App implementado para o desafio TracknMe.  
Foi utilizada Swift 4.0 para o desenvolvimento do app.

Frameworks Utilizados(gerenciados via CocoaPods):  
Alamofire -> Networking  
GoogleMaps -> Maps  
RealmSwift -> Para swift

Foram implementadas as funcionalidades de exibição de deslocamento no mapa, envio da posição do usuário (API chamada via Apiary), persistência das posições via RealmDB e listagem das posições com nome da rua obtido via Google GeoCoding API. A localização inicial é obtida via LocationManager (biblioteca inclusa no AppleSDK).

Não implementado:  
Exibição do personagem animado em 3D ao se deslocar entre posições.

Desenvolvido por:  
[Igor Maldonado Floôr](https://www.linkedin.com/in/igormfloor/)