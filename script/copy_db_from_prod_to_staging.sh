heroku pgbackups:capture -a snappea --expire
heroku pgbackups:capture -a snappea-staging --expire
heroku pgbackups:restore DATABASE `heroku pgbackups:url --a snappea` -a snappea-staging
heroku run rake db:migrate --app snappea-staging