## Скрипты для автоматического создания снапшотов

Это набор скриптов, для использования программы [zfSnap](/zfsnap/zfsnap/blob/legacy/) (версии 1) в автоматическом
режиме по расписанию, для создания снэпшотов. Разрабатывались для linux
платформы, на FreeBSD эти не тестировал, там родные скрипты хорошо
работают.

### Установка

1. Клонируйте репозиторий в какую-то папку
2. Скопируйте zfsnap.conf в /etc/zfsnap.conf
3. Cоздайте символические линки на zfsnap_create в папках /etc/cron.hourly,
   /etc/cron.daily, /etc/cron.weekly, /etc/cron.monthly (или только в
   тех, с какой переодичностю вам нужны снепшоты)


### Настройка

Для минимальной настройки, нужно в файле /etc/zfsnap.conf указать в каких
датасетех нужно автоматически создавать снепшоты
