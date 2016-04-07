# coding: utf-8
require_relative 'kuike'


domain = 'kameleon.com.cn' # insert IP address or domain name here

sh = CreateShell(domain,'kid',:keys=>['~/.ssh/id_rsa','~/.ssh/id_rsa.pub'],:port=>2222)

sh.runCommand "cd workspace/galileo"
sh.runCommand "ls -l"
sh.runCommand "git pull", [[/yes/,"yes"]]
netstatInfo = sh.runCommand "netstat -tlnp"
pid_jekyll = netstatInfo.match(/[0-9]+(?=\/jekyll)/)
sh.runCommand "kill -9 #{pid_jekyll}"
sh.runCommand "jekyll serve"

sh.close

