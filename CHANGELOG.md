# Changelog

Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/), versões em [SemVer](https://semver.org/lang/pt-BR/).

## [1.0.8] - 2026-11-12

### Adicionado
- **Qualidade automática** no menu do View (Gráficos): com a taxa de quadros abaixo do alvo, o jogo baixa o próprio
  nível de detalhe e devolve quando sobra folga. Desligada, 30, 40, 45 ou 60 FPS; vem em 30 FPS. Na VPS, com alvo
  60, foi de 48 para 61-65 FPS (nível 10).
- **Upscaling FSR 3.1** no menu do View: a cena é desenhada menor e o FSR 3.1 reconstrói em 1280x800. Qualidade
  (67%), Equilibrado (59%) e Desempenho (50%); vem em Qualidade. O ganho no Deck ainda vai ser medido.

### Mudado
- A resolução 16:10 agora é a resolução nativa do port (saída nova 1280x800, interface em 1920x1200 como antes), no
  lugar dos patches de resolução e de tela virtual; a escala e as faixas de LOD saem do patch de distância e vão
  pro port. Era isso que deixava a qualidade dinâmica, o FSR e os ajustes de LOD do menu avançado indisponíveis.
- A resolução nativa e o FSR 3.1 do iss_pc passam a aceitar a versão europeia (CUSA00004 1.07, mesmo executável da
  americana), com a mesma conferência de bytes.

## [1.0.7] - 2026-11-12

### Mudado
- Port atualizado com as correções do iss_pc de HayatoG até 07/11 (merge do ramo `developer`, 2a9aec2): tela
  branca ao absorver um poder (#637), câmera do executável CUSA00004 1.07 (#554), vibração com limite de comandos
  (#508) e chave de vibração no menu avançado, trackpads e vibração do Steam Deck (#723), qualidade dinâmica e
  upscaling FSR 3.1 no renderer v2 (#725, no menu avançado), entre outras.
- O que é do Deck continua igual: heap unificado B+C, coletor que mede só as texturas, clique dos trackpads por
  pressão, chacoalhar do Deck, menu do View. O cache de pipelines segue ligado no Deck (o upstream passou a
  desligar por padrão).

## [1.0.6] - 2026-11-09

### Mudado
- O port agora se chama **Deckport** (marca de todos os ports do Kewin para o Steam Deck): instalador, tela de
  atualização, menu do port (aba Sobre e selo do menu), atalho do instalador, vídeos tutoriais e README. O iss_pc de
  HayatoG e o shadPS4 aparecem nos créditos. O logo segue com o selo STEAMDECK VERSION e o título na Steam segue
  "inFAMOUS Second Son".
- Repositório renomeado para `KewinBR/deckport-infamous-ss` (o endereço antigo redireciona; instalações antigas
  seguem atualizando).

## [1.0.5] - 2026-10-24

### Adicionado
- A tela de atualização mostra o que mudou desde a versão instalada, no idioma do Deck.

## [1.0.4] - 2026-10-24

### Corrigido
- O botão Steam ainda podia travar o Deck em sessões longas. A causa de verdade: os passes nativos do renderer
  guardavam os buffers de comando de cada pico de cena pesada e nunca devolviam (chegava a ~3 GB de memória de vídeo).
  Agora o que sobra acima do necessário volta pro sistema.

## [1.0.3] - 2026-10-24

### Corrigido
- A proteção de memória da 1.0.2 apagava texturas em uso e o jogo engasgava nas batalhas. Agora ela só apaga texturas
  paradas há uns 20 segundos, poucas de cada vez.

## [1.0.2] - 2026-10-24

### Corrigido
- O botão Steam podia travar o Deck depois de um bom tempo de jogo: a memória de vídeo (que no Deck sai da RAM)
  enchia e o menu da Steam não conseguia abrir. Agora o port libera texturas fora de uso quando a memória livre do
  Deck cai abaixo de 1,5 GB.

## [1.0.1] - 2026-10-24

### Corrigido
- A aba Extras (Pular vídeos e Easter Eggs) agora aparece no menu do botão View; antes estava só no menu avançado.

## [1.0.0] - 2026-10-23

### Adicionado
- Instalador para o Modo Desktop do Steam Deck (toque e controle, português e inglês): acha os .pkg do jogo,
  extrai com o pkgx, instala o port e cria o atalho na Steam.
- Logo inFAMOUS SECOND SON + STEAMDECK VERSION (vertical e horizontal) e artes do instalador.
- Icones de botao do Deck no jogo (A, B, X, Y, MENU, PAD), gerados no Deck a partir dos pacotes de texto do jogo, em
  Python puro (15 idiomas em ~20 s).
- Texturas do Deck: minigame do spray (chacoalhar, virar) e tela de controles com os botoes de tras.
- Atalho na Steam com capa, banner, fundo, logo e icone; iniciador com atualizacao automatica.
- Extras > Easter Eggs no menu do port (desligado por padrao). Os arquivos levam so os blocos de textura
  redesenhados; o resto vem do jogo instalado (`ferramentas/tlgpatch.py`).
