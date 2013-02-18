require 'mail'


Mail.all.each do |mail|
  puts mail.parts[0].body  #=> {'charset' => 'ISO-8859-1'}
  puts mail.parts[1].body #=> {'name' => 'my.pdf'}
end