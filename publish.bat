@echo off
title blog publisher
echo type commit meaages please:
set /p m=
(git add -A)&&(git commit -m "%m%")&&(git push)&&(echo Publish Complete!)||(echo Error While Publish!)
pause 