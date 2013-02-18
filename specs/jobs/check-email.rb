require 'mail'

Mail.defaults do
  retriever_method :pop3, :address => "gator20.hostgator.com",
                   :port => 995,
                   :user_name => 'crmtesting@centracorporation.com',
                   :password => '0953acb',
                   :enable_ssl => true
end

Mail.all.each do |mail|
  puts mail.parts[0].body  #=> {'charset' => 'ISO-8859-1'}
  puts mail.parts[1].body #=> {'name' => 'my.pdf'}
end