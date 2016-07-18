@echo off
(git add -A)&&(git commit -m "auto push")&&(git push)&&(echo Publish Complete!)||(echo Error While Publish!)
pause