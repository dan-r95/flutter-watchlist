date=`date`
commit=`git rev-parse --short HEAD`
branch=`git rev-parse --abbrev-ref HEAD`
echo "const buildTime = '${date}'; const buildCommit = '${commit} / ${branch}';" > lib/login/build_info.dart