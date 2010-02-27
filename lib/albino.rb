require 'rubygems'
require 'open4'

class Albino
  @@bin = defined?(Rails) && ENV['RAILS_ENV']=='development'  ? 'pygmentize' : '/usr/local/bin/pygmentize'
  #@@bin = defined?(Rails) && ENV['RAILS_ENV']=='production'  ? 'pygmentize' : '/usr/bin/pygmentize'

  def self.bin=(path)
    @@bin = path
  end

  def self.colorize(*args)
    new(*args).colorize
  end

  def self.find_lexer(file_name)
    if arr = Albino.find_lexer_array(file_name)
      arr[1]
    else
      'plain'
    end
  end

  def self.find_lexer_name(file_name)
    if arr = Albino.find_lexer_array(file_name)
      arr[2]
    else
      'Text'
    end
  end

  def self.find_lexer_array(file_name)
    ext = File.extname(file_name)
    if arr = Albino.extensions.assoc(ext)
      arr
    end
  end
  
  def self.find_lexer_by_ext(ext)
    if arr = Albino.extensions.assoc(ext)
      arr
    end
    arr[1]
  end

  def self.name_extensions
    lexers = {}
    Albino.extensions.map { |a| lexers[a[2]] = a[0] }
    lexers.to_a.sort
  end

  def self.extensions
    [
      ['.as', 'as', 'ActionScript'],
      ['.sh', 'bash', 'Bash'],
      ['.bat', 'bat', 'Batchfile'],
      ['.cmd', 'bat', 'Batchfile'],
      ['.befunge', 'befunge', 'Befunge'],
      ['.boo', 'boo', 'Boo'],
      ['.bf', 'brainfuck', 'Brainfuck'],
      ['.b', 'brainfuck', 'Brainfuck'],
      ['.c-objdump', 'c-objdump', 'c-objdump'],
      ['.h', 'c', 'C'],
      ['.c', 'c', 'C'],
      ['.cl', 'common-lisp', 'Common Lisp'],
      ['.lisp', 'common-lisp', 'Common Lisp'],
      ['.el', 'common-lisp', 'Common Lisp'],
      ['.hpp', 'cpp', 'C++'],
      ['.c++', 'cpp', 'C++'],
      ['.h++', 'cpp', 'C++'],
      ['.cc', 'cpp', 'C++'],
      ['.hh', 'cpp', 'C++'],
      ['.cxx', 'cpp', 'C++'],
      ['.hxx', 'cpp', 'C++'],
      ['.cpp', 'cpp', 'C++'],
      ['.cpp-objdump', 'cpp-objdump', 'cpp-objdump'],
      ['.c++-objdump', 'cpp-objdump', 'cpp-objdump'],
      ['.cxx-objdump', 'cpp-objdump', 'cpp-objdump'],
      ['.cs', 'csharp', 'C#'],
      ['.css', 'css', 'CSS'],
      ['.d-objdump', 'd-objdump', 'd-objdump'],
      ['.d', 'd', 'D'],
      ['.di', 'd', 'D'],
      ['.pas', 'delphi', 'Delphi'],
      ['.patch', 'diff', 'Diff'],
      ['.diff', 'diff', 'Diff'],
      ['.dpatch', 'dpatch', 'Darcs Patch'],
      ['.darcspatch', 'dpatch', 'Darcs Patch'],
      ['.dylan', 'dylan', 'Dylan'],
      ['.hrl', 'erlang', 'Erlang'],
      ['.erl', 'erlang', 'Erlang'],
      ['.f', 'fortran', 'Fortran'],
      ['.f90', 'fortran', 'Fortran'],
      ['.s', 'gas', 'GAS'],
      ['.S', 'gas', 'GAS'],
      ['.kid', 'genshi', 'Genshi'],
      ['.[1234567]', 'groff', 'Groff'],
      ['.man', 'groff', 'Groff'],
      ['.hs', 'haskell', 'Haskell'],
      ['.phtml', 'html+php', 'HTML+PHP'],
      ['.htm', 'html', 'HTML'],
      ['.xhtml', 'html', 'HTML'],
      ['.xslt', 'html', 'HTML'],
      ['.html', 'html', 'HTML'],
      ['.ini', 'ini', 'INI'],
      ['.cfg', 'ini', 'INI'],
      ['.properties', 'ini', 'INI'],
      ['.io', 'io', 'Io'],
      ['.weechatlog', 'irc', 'IRC logs'],
      ['.java', 'java', 'Java'],
      ['.js', 'js', 'JavaScript'],
      ['.jsp', 'jsp', 'Java Server Page'],
      ['.lhs', 'lhs', 'Literate Haskell'],
      ['.ll', 'llvm', 'LLVM'],
      ['.lgt', 'logtalk', 'Logtalk'],
      ['.lua', 'lua', 'Lua'],
      ['.mak', 'make', 'Makefile'],
      ['.mao', 'mako', 'Mako'],
      ['.matlab', 'matlab', 'Matlab'],
      ['.md', 'minid', 'MiniD'],
      ['.moo', 'moocode', 'MOOCode'],
      ['.mu', 'mupad', 'MuPAD'],
      ['.myt', 'myghty', 'Myghty'],
      ['.py', 'numpy', 'NumPy'],
      ['.pyw', 'numpy', 'NumPy'],
      ['.sc', 'numpy', 'NumPy'],
      ['.objdump', 'objdump', 'objdump'],
      ['.m', 'objective-c', 'Objective-C'],
      ['.mli', 'ocaml', 'OCaml'],
      ['.mll', 'ocaml', 'OCaml'],
      ['.mly', 'ocaml', 'OCaml'],
      ['.ml', 'ocaml', 'OCaml'],
      ['.pm', 'perl', 'Perl'],
      ['.pl', 'perl', 'Perl'],
      ['.php[345]', 'php', 'PHP'],
      ['.php', 'php', 'PHP'],
      ['.pot', 'pot', 'Gettext Catalog'],
      ['.po', 'pot', 'Gettext Catalog'],
      ['.pytb', 'pytb', 'Python Traceback'],
      ['.pyw', 'python', 'Python'],
      ['.py', 'python', 'Python'],
      ['.sc', 'python', 'Python'],
      ['.raw', 'raw', 'Raw token data'],
      ['.rb', 'rb', 'Ruby'],
      ['.rbw', 'rb', 'Ruby (rbw)'],
      ['.rake', 'rb', 'Ruby (rake)'],
      ['.gemspec', 'rb', 'Ruby (gemspec)'],
      ['.rbx', 'rb', 'Ruby (rbx)'],
      ['.cw', 'redcode', 'Redcode'],
      ['.rhtml', 'rhtml', 'RHTML'],
      ['.rst', 'rst', 'reStructuredText'],
      ['.rest', 'rst', 'reStructuredText'],
      ['.scm', 'scheme', 'Scheme'],
      ['.st', 'smalltalk', 'Smalltalk'],
      ['.tpl', 'smarty', 'Smarty'],
      ['.S', 'splus', 'S'],
      ['.R', 'splus', 'S'],
      ['.sql', 'sql', 'SQL'],
      ['.tcl', 'tcl', 'Tcl'],
      ['.tcsh', 'tcsh', 'Tcsh'],
      ['.csh', 'tcsh', 'Tcsh'],
      ['.aux', 'tex', 'TeX'],
      ['.toc', 'tex', 'TeX'],
      ['.tex', 'tex', 'TeX'],
      ['.txt', 'text', 'Text only'],
      ['.vb', 'vb.net', 'VB.net'],
      ['.bas', 'vb.net', 'VB.net'],
      ['.vim', 'vim', 'VimL'],
      ['.xsl', 'xml', 'XML'],
      ['.rss', 'xml', 'XML'],
      ['.xslt', 'xml', 'XML'],
      ['.xsd', 'xml', 'XML'],
      ['.wsdl', 'xml', 'XML'],
      ['.xml', 'xml', 'XML'],
      ['.xsl', 'xslt', 'XSLT'],
      ['.xslt', 'xslt', 'XSLT'],
    ]
  end

  def initialize(target, lexer = :text, format = :html)
    @target  = File.exists?(target) ? File.read(target) : target rescue target
    @options = { :l => lexer, :f => format }
  end

  def execute(command)
    out = nil
    open4(command) do |pid, stdin, stdout, stderr|
      stdin.puts @target
      stdin.close
      out = stdout.read.strip
    end
    out
  end

  def colorize(options = {})
    execute @@bin + convert_options(options) + ' -O encoding=utf-8,style=colorful,linenos=1'
  end
  alias_method :to_s, :colorize
 

  def convert_options(options = {})
    @options.merge(options).inject('') do |string, (flag, value)|
      string + " -#{flag} #{value}"
    end
  end
end

