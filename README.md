# experimental-nixos

_実験的な NixOS Configuration_

---

### VirtualBoxの仮想マシンの初期設定の一部変更

**名前とオペレーティングシステム**

|項目|値|
|---|---|
|タイプ|Linux|
|Subtype|Other Linux|
|バージョン|Other Linux(64-bit)|

**ハードウェア**

|項目|値|
|---|---|
|メインメモリー|8192MB|
|プロセッサー数|2CPU|
|EFIを有効化|有効|

**ハードディスク**

|項目|値|
|---|---|
|仮想ハードディスクを作成する|有効|

**ハードディスクファイルの場所とサイズ**

|項目|値|
|---|---|
|サイズ|50GB|
|ハードディスクのファイルタイプと種類|VDI(Virtual Disk Image)|
|全サイズの事前割り当て|無効|

---

### VirtualBoxの仮想マシン作成後の一部設定変更

**設定 > Expert > ディスプレイ > スクリーン**

|項目|値|
|---|---|
|ビデオメモリー|128MB|
|3Dアクセラレーションを有効化|有効|

**設定 > Expert > ネットワーク > アダプター1 > ポートフォワーディング**

|項目|値|
|---|---|
|名前|SSH|
|プロトコル|TCP|
|ホストIP|-|
|ホストポート|2222|
|ゲストIP|-|
|ゲストポート|22|

---

### 初期構築

1. NixOSの仮想マシンの起動

2. Rootユーザーに切り替える
```bash
sudo -i
```

3. キーボードのレイアウトを`jp106`に変更する
```bash
loadkeys jp106
```

4. `nixos-init.sh`を取得する
```bash
curl -fsSL https://raw.githubusercontent.com/dev-hayato-shiina/experimental-nixos/main/nixos-init.sh -o /root/nixos-init.sh
```

5. `nixos-init.sh`を実行する
```bash
sh /root/nixos-init.sh
```

6. 一度仮想マシンを停止する
```bash
shutdown -h now
```

---

### 2回目以降

1. `configuration.nix`を置き換える
```bash
sudo rm /etc/nixos/configuration.nix && sudo curl -fsSL "https://raw.githubusercontent.com/dev-hayato-shiina/experimental-nixos/main/configuration.nix" -o /etc/nixos/configuration.nix
```

2. NixOS Rebuild
```bash
cd /etc/nixos && sudo nixos-rebuild switch
```
