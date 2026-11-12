#!/usr/bin/env bash
# Teste do Deckport na VPS-KEWIN, do jeito que o Deck abre (rodar.sh do pacote, renderer v2, passes nativos).
# Roda NA VPS. A pasta de teste fica montada em ~/steamdeck/deckport-teste (o cache de shaders e reaproveitado).
#   preparar <pacote.tar.gz> [port.tar.gz]   monta app/ e port/ (port.tar.gz opcional: troca so o port)
#   scripts <pasta com rodar.sh e deck/>     troca os scripts do app pelos do repo (sem montar o pacote)
#   rodar <rotulo> [VAR=valor ...]           abre, carrega o save, anda 10 s, abre o menu do View, fecha
#   limpar                                  apaga a pasta de teste e devolve o config.json de antes
# Resultado em ~/steamdeck/teste-<rotulo>.out (caminho do log do port na penultima linha).
set -uo pipefail
T=$HOME/steamdeck/deckport-teste
CFG=$HOME/.config/infamous-ss-deck/config.json
case ${1:-} in
preparar)
    rm -rf "$T"; mkdir -p "$T/port"; cd "$T"
    tar xzf "$2"; mv infamous-ss-deck app
    tar xzf "${3:-app/port.tar.gz}" -C port --strip-components=1
    mkdir -p app/user; cp -a "$HOME/steamdeck/iss_pc/port/user/savedata" app/user/
    [[ -f $CFG && ! -f $T/../deckport-config-antes.json ]] && cp "$CFG" "$T/../deckport-config-antes.json" || true
    mkdir -p "$(dirname "$CFG")"
    printf '{"versao": "teste", "port": "%s/port", "jogo": "%s", "atualizar": false}\n' "$T" \
        "$HOME/steamdeck/infamous-jogo" > "$CFG"
    echo "montado em $T" ;;
scripts)
    cp "$2/rodar.sh" "$T/app/rodar.sh"; cp -r "$2/deck/." "$T/app/deck/"; echo "scripts trocados" ;;
rodar)
    rot=$2; shift 2
    cd "$T/port"
    export XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 DISPLAY=:0
    export XAUTHORITY=$(ls /run/user/1000/.mutter-Xwaylandauth.* | head -1) DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
    mkdir -p /tmp/caca-q; : > /tmp/pad-q.txt; touch /tmp/inicio-q
    export TLG_CACA_DIR=/tmp/caca-q TLG_SHOT_EVERY_S=${SHOT:-15} TLG_SHOT_OVERLAY=1 TLG_PAD_FILE=/tmp/pad-q.txt
    env "$@" LANG=pt_BR.UTF-8 timeout 1800 bash "$T/app/rodar.sh" > "$HOME/steamdeck/teste-$rot-rodar.txt" 2>&1 &
    L=""
    for i in $(seq 1 1600); do
        sleep 1
        L=$(find out/logs -name "run-*.log" -newer /tmp/inicio-q 2>/dev/null | tail -1)
        if [[ -n $L ]] && grep -aq splash_europe "$L"; then break; fi
    done
    echo "splash em ${i}s"
    sleep 2; echo options > /tmp/pad-q.txt; sleep 1.6; : > /tmp/pad-q.txt; sleep 10
    for k in 1 2 3; do echo cross > /tmp/pad-q.txt; sleep 0.3; : > /tmp/pad-q.txt; sleep 5; done
    sleep ${ESPERA:-50}
    echo "ly=0" > /tmp/pad-q.txt; sleep 10; : > /tmp/pad-q.txt
    sleep ${DEPOIS:-30}
    echo view > /tmp/pad-q.txt; sleep 0.4; : > /tmp/pad-q.txt; sleep 8
    pkill -f "^$T/port/out/tlg-probe" || true; sleep 5; pkill -f "^$T/port/out/tlg-probe" || true
    pkill -f "^python3 $T/app/deck/" || true
    echo "$T/port/$L"
    echo FIM ;;
limpar)
    [[ -f $T/../deckport-config-antes.json ]] && mv "$T/../deckport-config-antes.json" "$CFG" || rm -f "$CFG"
    rm -rf "$T"; echo limpo ;;
*) sed -n 2,9p "$0"; exit 1 ;;
esac
