# desafio_digital_aligner

A proposta do desafio é desenvolver duas telas sendo uma para login e outra para upload de arquivos.

Para iniciar o projeto Flutter para web, busquei inicializar o projeto apenas para plataforma web, eliminando a necessidade de criar através do comando flutter create que traria diversos arquivos desnecessários para minha solução.
Por isso, no terminal inicie com o comando flutter create --project-name <nome do projeto> --platforms web <caminho da pasta onde quero criar>

## Estrutura de pastas criadas, abstraindo as pastas default

**Pasta raiz:**

- `assets/`: Contendo o arquivo de imagem utilizado no background da pagina de login.
- `lib/`: Contendo o código-fonte do aplicativo (minha pasta principal de desenvolvimento).
- `pubspec.yaml`: Contendo as dependências do projeto.

**Pasta `lib/`:**

- `models/`: Tem os modelos dos dados que vou representar.
- `pages/`: Tem as interfaces do usuário onde o usuário irá interagir.
- `repositories/`: Tem o repositório de dados que utilizei para manter o princípio da responsabilidade única.
- `main.dart`: Meu arquivo principal onde tudo pode ser renderizado para o navegador.

## Tomei os devidos cuidados em respeitar as boas Práticas de programação e princípios de responsabilidades

**Organização:**

- Pensei numa estrutura organizada em pastas e arquivos com nomes descritivos, facilitando a compreensão do projeto e manutenções futuras por outros desenvolvedores que peguem meu projeto.

**Modularidade:**

- Tomei o cuidado em dividir o código em módulos distintos, para facilitar tanto a manutenção quanto o reuso de código.

### Aplicando os princípios de responsabilidades

**Separação de Preocupações:**

- Minha estrutura separa as diferentes responsabilidades da aplicação, como a interface do usuário, a lógica de negócios e o acesso a dados.

**Coesão:**

- Cada módulo criado é coeso e possui uma única responsabilidade bem definida.

**Acoplamento Fraco:**

- Os módulos são fracamente acoplados, o que significa que eles dependem o mínimo possível uns dos outros.

## Resumo do arquivo `PageLogin.dart`

**Objetivo:** Controlar a interface da tela de login e registro da aplicação.

**Bibliotecas e Dependências:**

- `dart:convert`
- `dart:ui`
- `package:flutter/material`
- `package:http/http.dart`
- `./page_main.dart`
- `../repositories/repository.dart`

**Classes:**

- `PageLogin`: Estrutura principal da tela.
- `_PageLoginState`: Gerencia o estado interno da tela.

**Funções:**

- `_requestRegister`: Envia requisição POST para registrar um novo usuário.
- `_requestLogin`: Envia requisição POST para realizar o login.
- `_navigateToMainPage`: Navega para a tela principal após o login ter dado sucesso.

**Widgets:**

- `PageView`: Gerencia as telas de login e registro.
- `TextFormField`: Campos de entrada para email, senha e nome (no registro).
- `ElevatedButton`: Botões para enviar as requisições.
- `SnackBar`: Apresenta mensagens de notificação.

## Resumo do arquivo `page_main.dart`

**Importações de Arquivos:**

- `dart:convert`: Usado para decodificar respostas JSON do servidor.
- `dart:typed_data`: Usado para lidar com dados binários que representam arquivos carregados.
- `package:download/download.dart`: Um pacote de terceiros para baixar arquivos.
- `package:file_picker/file_picker.dart`: Usado para permitir que os usuários selecionem arquivos do armazenamento do dispositivo.
- `package:flutter/material.dart`: Fornece os widgets e funcionalidades básicas para construir interfaces de usuário.
- `package:desafio_digital_aligner/repositories/repository.dart`: Uma classe do repositório que contém métodos para interagir com a API do backend (para carregar, baixar ou buscar dados).
- `package:desafio_digital_aligner/models/model_file_attachment.dart`: Uma classe de modelo que representa um anexo de arquivo com propriedades como nome do arquivo e bytes do arquivo.
- `package:desafio_digital_aligner/models/model_file_upload.dart`: Uma classe de modelo personalizada que representa um arquivo carregado com propriedades recuperadas da resposta do servidor (por exemplo, ID, nome do arquivo, URL de download).
- `page_user.dart`: Arquivo que contém elementos de interface do usuário para exibir informações do usuário.

**Definições de Classe:**

- `PageMain`: Esta classe representa a página principal da aplicação. Ela herda de `StatefulWidget`, indicando que gerencia seu próprio estado interno.

**Gerenciamento de Estado:**

- `_PageMainState`: Esta classe gerencia o estado do widget `PageMain`. Ele contém variáveis ​​de membro como:
  - `_fileAttachmentList`: Uma lista de objetos `FileAttachment` que representam arquivos que o usuário anexou, mas ainda não carregou.
  - `_fileUploadList`: Uma lista de objetos `FileUpload` que representam arquivos que foram carregados com sucesso no servidor.
  - `_sending`: Uma bandeira booleana que indica se os arquivos estão sendo carregados no momento.

**Métodos de Construção de Widgets:**

- `initState`: Este método é chamado quando o widget é inserido pela primeira vez na árvore de widgets. Aqui, ele vai buscar a lista inicial de arquivos carregados usando `_getFileUploadList`.
- `build`: Este método constrói a interface do usuário do widget `PageMain`. Ele retorna um widget `Scaffold` que contém uma barra de aplicativos, um corpo e um botão de ação flutuante para ações do usuário.

**Funcionalidades-chave:**

- **\_getFileUploadList**: Esta função busca a lista de arquivos carregados do servidor usando o método `getFileUploadList` do repositório. Após uma resposta bem-sucedida, ele atualiza a variável de estado `_fileUploadList` e reconstrói a interface do usuário.
- **\_attachFile**: Esta função permite que o usuário selecione um arquivo usando `FilePicker`. Ele verifica se o arquivo já está na lista de anexos. Se não, ele cria um novo objeto `FileAttachment` e o adiciona a `_fileAttachmentList`, disparando uma atualização da interface do usuário.
- **\_sendFile**: Esta função envia um anexo de arquivo selecionado para o servidor usando o método `sendFile` do repositório. Se for bem-sucedido, ele remove o arquivo da `_fileAttachmentList`, adiciona as informações do arquivo carregado (`FileUpload`) à `_fileUploadList` e reconstrói a interface do usuário.
- **\_deleteFile**: Esta função exclui um arquivo previamente carregado do servidor usando o método `deleteFile` do repositório. Após uma resposta bem-sucedida, ele remove o objeto `FileUpload` correspondente de `_fileUploadList` e atualiza a interface do usuário.
- **\_sendFiles**: Esta função envia todos os arquivos na `_fileAttachmentList` para o servidor sequencialmente usando `_sendFile` para cada arquivo. Ele define a bandeira `_sending` como verdadeira durante o carregamento e atualiza a interface do usuário para indicar o progresso.

**Elementos da Interface do Usuário:**

- A barra no header exibe o título "Bem-vindo(a)" e fornece ações do usuário como acessar informações do usuário e sair.
- O corpo contém duas seções principais:
  - Uma seção para exibir arquivos carregados anteriormente (se houver) recuperados do servidor.
  - Uma seção para permitir que os usuários façam uploads de arquivos.

### Utilidade no Dia a Dia

Este projeto oferece uma solução prática para diversas situações do dia a dia que exigem o envio de arquivos para um servidor:

**Profissionais:**

- Envio de documentos, relatórios, apresentações e outros arquivos para clientes ou colegas.
- Compartilhamento de imagens, vídeos e outros conteúdos multimídia.

**Estudantes:**

- Entrega de trabalhos, tarefas e projetos acadêmicos.
- Compartilhamento de materiais de estudo com colegas.

**Uso Pessoal:**

- Envio de fotos, vídeos e outros arquivos para amigos e familiares.
- Backup de arquivos importantes em um servidor remoto.

### Execução Local

Para executar o projeto localmente, siga os seguintes passos:

1. **Instale o Flutter SDK:** [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. **Clone o repositório do projeto:** `git clone https://github.com/desafio-digital-aligner/desafio_digital_aligner.git`
3. **Navegue até a pasta do projeto:** `cd desafio_digital_aligner`
4. **Instale as dependências do projeto:** `flutter pub get`
5. **Execute o aplicativo:** `flutter run`

**Meus sinceros agradecimentos pela oportunidade do desafio proposto**
