# Projeto Enquetec
![Banner_enquetec](https://github.com/matheusrmatias/EnquetecApp/assets/115509118/b61cd540-89ae-476a-9790-fea5370d9cc5)
Um app com o intuito de aperfeiçoar o ensino nas Fatecs.

## Indíce
- <a href="#início">🏁 Início</a>
- <a href="#principais-funcionalidades-do-projeto">📱 Funcionalidades do Projeto</a>
- <a href="#layout">📺 Layout</a>
- <a href="#tecnologias-utilizadas">🛠 Tecnologias Utilizadas</a>

## 🏁Início

Antes de começar é importante inserir suas credenciais do firebase no aplicativo, sendo assim: 
- Coloque o arquivo "google-service.json" na pasta app do android.
- Crie um arquivo "config.json" na raiz do projeto com a seguinte informação:

Esse arquivo é necessário para as push notifications.
```json
{
  "cloud_messaging_key" : "SUA CHAVE CLOUD MESSAGING"
}
```

Para iniciar o projeto insira o seguinte comando no terminal:
```bash
flutter run -d "SEU DISPOSITIVO" --dart-define-from-file=config.json
```

## 📱Principais Funcionalidades do Projeto
 - [x] WebScraping do SIGA
 - [x] Push Notifications
 - [x] Enquetes
 - [x] Mensagens Diretas

## 📺Layout
![Tela de Login Aluno](https://github.com/matheusrmatias/EnquetecApp/assets/115509118/4141faae-ea4b-4d72-ae70-63050de8f26c)
![Tela Home Aluno](https://github.com/matheusrmatias/EnquetecApp/assets/115509118/592a9e6b-062d-4886-913e-e0e87ac62904)
![Enquetes](https://github.com/matheusrmatias/EnquetecApp/assets/115509118/3316a807-4395-4e3d-b772-8e4bd7915523)


## 🛠Tecnologias Utilizadas
1. ![Flutter]("https://flutter.dev/")
2. ![Dart]("https://dart.dev/")
3. ![Firebase]("https://firebase.google.com/")
