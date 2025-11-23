#!/usr/bin/env sh

# abort on errors
set -e

# build
echo "Building for production..."
npm run build

# navigate into the build output directory
cd dist

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# if you are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:olabisiadewunmi673-design/frontend.git main:gh-pages

cd -

echo "Deploy complete!"
