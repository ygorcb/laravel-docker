set -e

wait_database () {
    dockerize \
        -wait tcp://database:3306 \
        -timeout 30s \
        -wait-retry-interval 3s
}

migrate_database () {
    wait_database
    php artisan migrate
}

migrate_database

exec "$@"