date=`date`
commit=`git rev-parse --short HEAD`
branch=`git rev-parse --abbrev-ref HEAD`
echo "const buildTime = '${date}'; const buildCommit = '${commit} / ${branch}'; GOOGLE_CLIENT_ID = 'qDZW8-xH9-b013ARfMO10ybS'" > lib/login/build_info.dart