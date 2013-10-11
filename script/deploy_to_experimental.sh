echo '--------------------------------------------------------------------------------'
echo 'THIS SCRIPT REQUIRES A REMOTE CALLED experimental WHICH POINTS TO snappea-experimental'
echo '--------------------------------------------------------------------------------'
echo 'which branch do you want to deploy to snappea-experimental - or type q to quit'
read branch_to_deploy
if [[ $branch_to_deploy == q ]]
then
  exit
fi
set -e

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea (production)'
echo '--------------------------------------------------------------------------------'
# heroku pgbackups:capture --app snappea --expire

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Restoring production database to experimental'
echo '--------------------------------------------------------------------------------'
heroku maintenance:on --app snappea-experimental
# heroku pg:reset DATABASE_URL --app snappea-experimental --confirm snappea-experimental
# heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-experimental --confirm snappea-experimental

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Deploying code from branch' $branch_to_deploy 'to experimental'
echo '--------------------------------------------------------------------------------'
git push --force experimental $branch_to_deploy:master

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Migrating database to new version'
echo '--------------------------------------------------------------------------------'
heroku run rake db:migrate --app snappea-experimental
heroku maintenance:off --app snappea-experimental
echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'DEPLOYMENT COMPLETED'
echo '--------------------------------------------------------------------------------'
