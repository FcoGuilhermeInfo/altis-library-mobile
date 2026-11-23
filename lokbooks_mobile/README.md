# LokBooks Mobile

Aplicativo mobile de gerenciamento de biblioteca desenvolvido com Flutter e Dart, integrado à API do sistema LokBooks.

## Tecnologias utilizadas

- **Flutter** — framework para desenvolvimento mobile.
- **Dart** — linguagem de programação.
- **Dio** — comunicação com a API REST.
- **GoRouter** — gerenciamento de rotas e navegação.
- **SharedPreferences** — armazenamento local de preferências.
- **JWT** — autenticação por token.
- **Spring Boot** — tecnologia utilizada no backend.

## Como executar

### 1. Pré-requisitos

- Flutter SDK instalado.
- Android Studio ou Visual Studio Code.
- Emulador Android ou dispositivo físico.
- Backend do LokBooks em execução.

### 2. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
```

### 3. Acessar a pasta do projeto

```bash
cd lokbooks_mobile
```

### 4. Instalar as dependências

```bash
flutter pub get
```

### 5. Configurar a API

Verifique o endereço do backend no arquivo:

`lib/core/services/http/api_client.dart`

Configure o endereço de acordo com o ambiente de execução.

### 6. Executar o aplicativo

```bash
flutter run
```

## Gerar APK

Para gerar o APK de release:

```bash
flutter build apk --release
```

O arquivo será gerado em:

`build/app/outputs/flutter-apk/app-release.apk`

