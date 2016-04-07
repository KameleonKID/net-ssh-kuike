# coding: utf-8
require_relative 'lib/shell'
require 'net/ssh'

#colorize
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end
#
# shell expansion
class Net::SSH::Shell
  def execAndOutput(command, ifwait=true)
    #first print a line
    puts "\n==============================>\n"
    #execute and get the process
    process = self.execute command
    # callbacks
    process.on_output do |sh,out|
      print out.bg_cyan
      yield process,out unless not block_given?
    end
    # end callbacks
    puts "\nSSH::Shell.execute '#{process.command}'\n"
    # to wait
    self.wait! unless ifwait==false
    #return
    return process
  end

  def handleFeedbackQueue (process,data,fdbkQueue)
    # fdbkQueue : [[RegExp1,commandString1],[RegExp2,commandString2]...]
    if fdbkQueue != [] and fdbkQueue != nil
      if data =~ fdbkQueue[0][0]
        process.send_data(fdbkQueue[0][1]+"\n")
        puts "\nSSH::Process.send_data: #{fdbkQueue[0][1]}\n"
        fdbkQueue.delete_at(0)
      end
    end
  end
  # if you have to answer something in a process ,use the method below
  def runCommand (command,fdbkQueue=nil)
    processData = ''
    process = self.execAndOutput command do |process,outData|
      processData += outData
      handleFeedbackQueue(process,outData,fdbkQueue)
    end
    return processData
  end
  # close the session
  def close
    self.session.close
  end
end
#end of class
# To create a shell
def CreateShell(host, username=nil, options={})
  session = Net::SSH.start(host, username, options)
  shell = session.shell
  return shell
end