@echo off
(git add -A)&&(git commit -m 'add_some_posts')&&(git push)&&(echo Publish Complete!)||(echo Error While Publish!)
pause