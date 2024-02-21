Сервис Keepalived балансирует нагрузку (L4 TCP/UDP балансировщик) и позволяет автоматизировать переключение Virtual IP адресов между узлами кластера. Узлы кластера могут находиться в одном из состояний:
- Master - узел с активным VIP.
- Backup - узел, на котором активируется VIP в случае падения мастера.
- Fault - узел, который больше не является мастером из-за сбоя проверки скрипта track script или неполадок в работе keepalived.

Для определения доступности Master узла используется протокол VRRP. Мастер периодически рассылает multicast или unicast пакеты всем Backup узлам. Если Backup узлы перестают получать пакеты от мастера, то Backup узел с самым высоким приоритетом активирует на себе VIP.

Установка keepalived
`apt install keepalived`

Конфигурация keepalived хранится в `/etc/keepalived/keepalived.conf`. По умолчанию keepalived не отрабатывает сценарии изоляции и партиционирования сети, что может приводит к ситуации Split Brain и появлению нескольких мастеров. Для решения этой проблемы можно создать скрипт, который будет периодически выполнять проверки на узлах, и в случае сбоя переводить узел в Fault состояние. Если не задан параметр weight, то завершение скрипта с кодом возврата 0 считается за успешную проверку, а любой другой отличный от 0 считается за неуспешную проверку.

Пример конфигуации для трехузлового кластера, где узлам присвоены IP адреса 192.168.1.11, 192.168.1.12 и 192.168.1.13 соответственно.

Пример конфигурации `keepalived.conf` на узле 192.168.1.11 с проверкой на сетевую изоляцию. Конфигурация keepalived.conf на двух других узлах отличается в части unicast_src_ip и unicast_peer.

Пример скрипта для проверки изоляции `check.sh` на всех трех узлах. Скрипт прингует все узлы кластера, и в случае, если на icmp request отвечает <=50% узлов, возвращает exit 1.
