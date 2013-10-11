echo '--------------------------------------------------------------------------------'
echo 'THIS SCRIPT REQUIRES A REMOTE CALLED staging WHICH POINTS TO snappea-staging'
echo '--------------------------------------------------------------------------------'
set -e

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea (production)'
echo '--------------------------------------------------------------------------------'
heroku pgbackups:capture -a snappea --expire

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea-staging - to enable rollbacks'
echo '--------------------------------------------------------------------------------'
heroku pgbackups:capture -a snappea-staging --expire

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Restoring production database to staging'
echo '--------------------------------------------------------------------------------'
heroku maintenance:on --app snappea-staging
heroku pg:reset DATABASE_URL --app snappea-staging --confirm snappea-staging
heroku pgbackups:restore DATABASE `heroku pgbackups:url -a snappea` -a snappea-staging --confirm snappea-staging

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Deploying code from branch development to staging'
echo '--------------------------------------------------------------------------------'
# git push --force staging development:master

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Migrating database to new version'
echo '--------------------------------------------------------------------------------'
heroku run rake db:migrate --app snappea-staging
heroku maintenance:off --app snappea-staging
echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'DEPLOYMENT COMPLETED'
echo '--------------------------------------------------------------------------------'
