# Bicos App

Marketplace que conecta clientes a prestadores de serviço. Desenvolvido em **Flutter**.

## Funcionalidades

- **Dois perfis:** Cliente (contrata) e Prestador (oferece serviço)
- **Onboarding:** Tela inicial → Sobre o app → Seleção de perfil
- **Autenticação:** Login e cadastro para ambos os perfis com validação
- **Home com mapa:** Prestadores próximos via OpenStreetMap (`flutter_map` + `geolocator`)
- **Categorias:** Busca por categoria com cards de prestadores
- **Solicitar orçamento:** Descrição, data estimada e valor sugerido
- **Chat:** Mensagens de texto e imagem entre cliente e prestador
- **Acompanhamento:** Timeline visual (Orçamento → Andamento → Pagamento → Finalizado)
- **Avaliação:** Sistema de estrelas com CustomPainter e drag
- **Favoritos:** Favoritar/desfavoritar prestadores
- **Perfil:** Edição de dados e senha
- **Recuperar senha:** Fluxo de e-mail → código → nova senha

## Tecnologias

| Pacote | Versão |
|--------|--------|
| Flutter | SDK 3.6+ |
| Provider | 6.1+ |
| Dio | 5.4+ |
| Google Fonts | 6.0+ |
| flutter_map | 7.0+ (OpenStreetMap) |
| geolocator | 13.0+ |
| image_picker | 1.0+ |
| shared_preferences | 2.2+ |
| intl | 0.19+ |

## Estrutura

```
lib/
├── cliente_pages/    # Telas do perfil cliente
├── prestador_pages/  # Telas do perfil prestador
├── inicio_pages/     # Onboarding, auth, menu, perfil
├── components/       # Widgets reutilizáveis (AppHeader, AppImage, Mapa)
├── core/             # Cores, estilos, helpers
├── models/           # DTOs e modelos de dados
├── services/         # API client e serviços HTTP
├── providers/        # ChangeNotifiers (auth, favoritos)
├── storage/          # SharedPreferences wrapper
├── data/             # Dados mock de fallback
└── shared_pages/     # Páginas compartilhadas (serviço concluído)
```

## Setup para Windows

1. Instalar Flutter SDK, Java 21+ e PostgreSQL
2. Clonar os dois repositórios (frontend + backend)
3. Seguir as instruções de setup do backend primeiro
4. Voltar para este diretório e executar:

```bash
flutter pub get
flutter run -d windows
```

## Pré-requisitos

- Flutter SDK 3.6 ou superior
- Backend rodando em `http://localhost:8080`

## Como executar

```bash
flutter pub get
flutter run
```

> Certifique-se de que o backend esteja rodando antes de usar o app.

## Status do projeto

Projeto acadêmico — 5º período de Análise e Desenvolvimento de Sistemas.
