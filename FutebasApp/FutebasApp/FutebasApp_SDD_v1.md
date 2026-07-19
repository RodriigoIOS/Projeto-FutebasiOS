# SDD — FutebasApp (v1 / MVP)

## 1. Visão Geral

FutebasApp é um app iOS para organizar partidas de futebol amador entre amigos. O MVP resolve o problema mais básico: **criar uma partida e ver a lista de partidas criadas**, com um cronômetro por partida para acompanhar o tempo de jogo em andamento.

Não é um app de gestão de campeonato, nem tem times/estatísticas ainda — isso vem depois.

## 2. Escopo do MVP

**Incluso:**
- Criar partida (título, local, data/hora)
- Listar partidas criadas
- Cronômetro por partida (start/pause, exibido na lista ou no detalhe da partida)

**Fora do escopo (próximas fases):**
- Editar/excluir partida
- Convidar jogadores / lista de presença
- Login/autenticação de usuário
- Times, placar, estatísticas

> **Por quê esse corte?** Em VIP-C cada funcionalidade nova tende a virar uma cena nova (ou pelo menos um novo caso de uso no Interactor). Começar enxuto evita que você aprenda o padrão já lidando com combinação de fluxos complexos — dá pra sentir o ciclo Request → Interactor → Response → Presenter → ViewModel → Display de forma limpa antes de escalar.

## 3. Stack Técnica

| Camada | Escolha | Porquê |
|---|---|---|
| Linguagem | Swift | — |
| UI | UIKit + 100% ViewCode | Sem Storyboard/XIB — você constrói tudo via `NSLayoutConstraint`/anchors, o que força entender o ciclo de vida de view e Auto Layout na unha |
| Arquitetura | VIP-C (VIP + Coordinator) | Ver seção 4 |
| Persistência | Firebase (Firestore) | Sem backend próprio pra manter o foco na arquitetura iOS, não na infra |
| Cronômetro | `Timer` local (não persistido no Firestore por enquanto) | Cronômetro é estado efêmero de tela — persistir isso ainda é decisão em aberto para quando houver "retomar partida depois de fechar o app" |

## 4. Arquitetura VIP-C

**VIP** = View - Interactor - Presenter (o "C" de Clean Swift original vira Coordinator aqui, no lugar do Router).

Fluxo de uma cena:

```
ViewController -> Interactor -> Worker (Firebase, etc)
Interactor -> Presenter -> ViewController (via protocolo DisplayLogic)
ViewController -> Coordinator (navegação, fora da cena)
```

Cada cena tem 4 arquivos principais:
- `XxxViewController.swift` — só exibe dados (ViewModel) e captura eventos de UI. Não tem lógica de negócio.
- `XxxInteractor.swift` — recebe `Request`, executa regra de negócio/chama Worker, monta `Response`
- `XxxPresenter.swift` — recebe `Response`, formata em `ViewModel` (strings prontas, cores, etc)
- `XxxWorker.swift` (quando precisa) — acesso a dados externos (Firestore)

Navegação **não mora dentro da cena**. Um `Coordinator` externo escuta a ViewController via protocolo de delegate e decide pra onde ir.

> **Por quê separar assim?** A regra de ouro do VIP é: dado só anda numa direção por vez (unidirectional data flow) e cada camada só conhece o protocolo da vizinha, nunca a implementação. Isso é o que te dá testabilidade — você consegue testar o Interactor com um mock de Presenter sem precisar de UIKit rodando.

## 5. Estrutura de Pastas

```
FutebasApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
├── Scenes/
│   ├── MatchList/
│   │   ├── MatchListModels.swift
│   │   ├── MatchListInteractor.swift
│   │   ├── MatchListPresenter.swift
│   │   ├── MatchListViewController.swift
│   │   ├── MatchListWorker.swift
│   │   └── MatchListCoordinator.swift
│   └── CreateMatch/
│       ├── CreateMatchModels.swift
│       ├── CreateMatchInteractor.swift
│       ├── CreateMatchPresenter.swift
│       ├── CreateMatchViewController.swift
│       ├── CreateMatchWorker.swift
│       └── CreateMatchCoordinator.swift
├── Models/
│   └── Match.swift
├── Services/
│   └── FirestoreService.swift
└── Common/
    └── ViewCode/
        └── ViewCodeProtocol.swift
```

> **Por quê `Coordinator` dentro da pasta da cena e não numa pasta central?** Cada Coordinator de cena só conhece o "próximo passo" daquele fluxo. Um `AppCoordinator` central orquestra QUEM inicia primeiro, mas delega pros coordinators locais. Isso evita um Coordinator gigante conhecendo o app inteiro.

## 6. Modelo de Dados

```swift
struct Match: Identifiable, Codable {
    let id: String
    var title: String
    var location: String
    var date: Date
    var elapsedSeconds: Int   // estado do cronômetro, atualizado localmente
    var isTimerRunning: Bool
}
```

> **Por que `elapsedSeconds` como `Int` e não calcular na hora?** Guardar o valor bruto facilita mostrar o cronômetro pausado corretamente e evita lidar com fuso horário/drift de `Date` toda vez que a lista recarrega.

## 7. Fluxos Principais

### 7.1 Criar Partida
1. Usuário toca em "Nova Partida" na `MatchListViewController`
2. `MatchListCoordinator` apresenta `CreateMatchViewController`
3. Usuário preenche título, local, data → toca "Salvar"
4. `CreateMatchInteractor` monta o `Match`, chama `CreateMatchWorker.save()`
5. Worker grava no Firestore
6. `CreateMatchPresenter` formata sucesso/erro → `CreateMatchViewController` exibe
7. `CreateMatchCoordinator` fecha a tela e volta pra lista

### 7.2 Listar Partidas
1. `MatchListViewController` aparece → dispara `Request` pro Interactor
2. `MatchListInteractor` chama `MatchListWorker.fetchMatches()` (listener do Firestore)
3. Cada atualização do Firestore gera nova `Response` → `Presenter` formata `ViewModel`
4. `ViewController` atualiza a `UITableView`/`UICollectionView`

### 7.3 Cronômetro por Partida
1. Cada célula da lista tem um botão de play/pause
2. Toque dispara `Request` (ex: `.toggleTimer(matchId:)`) pro `MatchListInteractor`
3. Interactor mantém um `Timer` local por partida ativa, incrementando `elapsedSeconds`
4. A cada tick, gera `Response` → `Presenter` formata (`"12:45"`) → célula atualiza

> **Ponto de atenção que vamos validar juntos depois:** rodar múltiplos `Timer` dentro do Interactor de uma lista pode ficar pesado se houver muitas partidas simultâneas. Pra MVP tá ótimo; se crescer, migramos pra um único `Timer` "tick" central que atualiza todos os cronômetros ativos de uma vez.

## 8. Próximos Passos (pós-MVP)
- Autenticação (Firebase Auth)
- Detalhe da partida (tela própria, hoje o cronômetro fica só na lista)
- Convidar jogadores / confirmar presença
- Editar e excluir partida

---
*Documento vivo — atualizar conforme decisões mudarem durante o desenvolvimento.*
