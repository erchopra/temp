echo '--------------------------------------------------------------------------------'
echo 'THIS SCRIPT REQUIRES A REMOTE CALLED heroku WHICH POINTS TO snappea'
echo '--------------------------------------------------------------------------------'

echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Capturing backup of snappea (production)'
echo '--------------------------------------------------------------------------------'
heroku pgbackups:capture -a snappea --expire

heroku maintenance:on --app snappea
echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'Deploying code from master branch to production'
echo '--------------------------------------------------------------------------------'
git push --force heroku master
heroku run rake db:migrate --app snappea
heroku maintenance:off --app snappea
echo '--------------------------------------------------------------------------------'
echo $(date  +"%T") 'DEPLOYMENT COMPLETED'
echo '--------------------------------------------------------------------------------'