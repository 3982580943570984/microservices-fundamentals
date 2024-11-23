# Redis
## Установка
```text
$ scoop install redis
```

## Запуск
```text
$ redis-server
```

## Использование через консоль
### Проверка работоспособности сервера
```text
$ redis-cli ping
```
### Получение значения ключа
```text
$ redis-cli
127.0.0.1:6379> KEYS *
127.0.0.1:6379> GET <key_value>
```