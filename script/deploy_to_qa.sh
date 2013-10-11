echo '--------------------------------------------------------------------------------'
echo 'THIS SCRIPT REQUIRES A REMOTE CALLED qa WHICH POINTS TO snappea-qa'
echo '--------------------------------------------------------------------------------'
echo 'which branch do you want to deploy to snappea-qa - or type q to quit'
read branch_to_deploy
if [[ $branch_to_deploy == q ]]
then
  exit
fi
set -e

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea (production)'
echo '--------------------------------------------------------------------------------'
heroku pgbackups:capture --app snappea --expire

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea-qa - to enable rollbacks'
echo '--------------------------------------------------------------------------------'
heroku pgbackups:capture --app snappea-qa --expire

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Restoring production database to qa'
echo '--------------------------------------------------------------------------------'
heroku maintenance:on --app snappea-qa
heroku pg:reset DATABASE_URL --app snappea-qa --confirm snappea-qa
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-qa --confirm snappea-qa

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Deploying code from branch m3 to qa'
echo '--------------------------------------------------------------------------------'
git push --force qa $branch_to_deploy:master

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Migrating database to new version'
echo '--------------------------------------------------------------------------------'
heroku run rake db:migrate --app snappea-qa
heroku maintenance:off --app snappea-qa
echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'DEPLOYMENT COMPLETED'
echo '--------------------------------------------------------------------------------'
