Ansible Playbooks for OpenStack Havana
=======================================


本ツールは OSS のオーケストレーションツール「Ansible」
（http://ansible.cc/ ）を使って OpenStack Havana All-in-one 環境をインストールする
ためのAnsible のPlaybook集です。


環境要件
--------

 * Ansible 1.2 以降
 * メモリ 2GB 以上の x86-64 マシン（１台以上）
 * Ubuntu 12.04.2
 * インターネットに接続可能な環境（HTTP プロキシ使用可能）

ネットワーク環境
----------------

以下の２セグメントが存在するネットワーク環境を想定しています。

 * 外部 LAN (External LAN)  
   エンドユーザが VM や OpenStack Dashboard/API にアクセスする為の LAN
 * 内部 LAN（Internal LAN)  
   OpenStack のコンポーネント群が内部通信に使用する為の LAN

レシピ上、インストール対象の x86-64 マシンに２つのネットワーク・インター
フェース(NIC)があり、それらが以下の通りに接続されている事を想定していま
す。

 * NIC#1 → 内部 LAN
 * NIC#2 → 外部 LAN

なお、現在のレシピは Ansible 実行マシンとインストール先のマシン群が内部
LAN で接続されている必要があります。外部 LAN で接続されている場合、ネッ
トワークゲートウェイの NIC 設定で通信が切断されてしまい、レシピ実行が失
敗します。

インストール手順
----------------

1 は全マシン、2 以降は Ansible 実行マシン上で実施します。

 1. x86-64 マシンに Ubuntu 12.04.2 をインストールします。  外部 LAN ・
    内部 LAN 共に DHCP でも構いませんが、DHCP を使用しない場合はOS イン
    ストール時に各ネットワークのパラメータを設定する必要があります。

 2. Python の開発環境と pwgen をインストールします。

     ```
     sudo apt-get update -y
     sudo apt-get install -y python-dev pwgen git python-pip
     sudo pip install Jinja2
     ```

 3. git で ansible をインストールします。

     ```
     git clone https://github.com/ansible/ansible.git
     cd ansible
     python setup.py build
     sudo -E python setup.py install
     ```

 4. 本ツールを展開します。

     ```
     git clone https://github.com/bit-isle-rd/openstack-training.git
     cd openstack-training/openstack-ansible.3b
     ```

 5. /etc/hosts に OpenStack インストール先サーバの設定を行います。この
    際、各ホストに設定する IP アドレスは内部LAN用である必要があります。


 6. Ansible を実行します。  

     ```
     ansible-playbook site.yml
     ```

    SSH パスワードを聞かれるので入力します。sudo パスワードも聞かれます
    が、デフォルト値が SSH パスワードになっているのでそのまま Enter で
    構いません。

    SSH パスワード、sudo パスワードが不要な場合、ansible.cfg ファイル中の
    当該パラメータの値を False にして下さい。



謝辞
----

本ツールの作成にあたりお世話になった以下の方々に御礼申し上げます。

 * quantum-ansible リポジトリのメンテナ Darragh O'Reilly。
   Darragh の作品無しでは本ツールは有り得なかったでしょう。
 * openstack-ansible-modules リポジトリのメンテナ Lorin Hochstein。
   Glance/Keystone 用 Ansible モジュールを使わせて頂きました。
 * Ansible 開発元の AnsibleWorks。
   Ansible は使いやすく、希少な OSS オーケストレーションツールです。
 * OpenStack コミュニティ。
   素晴らしい OSS クラウド基盤をありがとう。
 * 吉山 あきら <akirayoshiyama@gmail.com>からforkしました。
