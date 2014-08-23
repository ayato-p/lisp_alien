require 'json'
require 'lisp'

SLACK_TOKEN = '9Q3zN2gbqO7rFlI8cJRztpCB'
TRIGGER_WORD = '#alien'

LispAlien::App.controllers :lisp_alien do
  post :alien do
    return 401 unless SLACK_TOKEN == params[:token]

    r = params[:text].split
    trigger = r.shift
    command = r.shift
    args = r.join(' ')

    return 200 unless trigger == TRIGGER_WORD
    user_name = params[:user_name]

    result = case command
             when 'lisp'
               Lisp.eval(args) rescue '< Oh... sorry I can\'t evaluate your input Symbol expression.'
             when 'help'
               usage
             when 'hello'
               '< Hello, world!!'
             else
               "< Hello, #{user_name}. What\'s up?"
             end

    {text: result, username: user_name}.to_json
  end

  helpers do
    def usage
<<-eos
Commands:
  #alien lisp args
  #alien hello
  #alien help
eos
    end
  end
end
