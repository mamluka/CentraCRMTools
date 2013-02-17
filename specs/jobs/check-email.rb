require 'mail'

Mail.defaults do
  retriever_method :pop3, :address => "gator20.hostgator.com",
                   :port => 995,
                   :user_name => 'crmtesting@centracorporation.com',
                   :password => '0953acb',
                   :enable_ssl => true
end

Mail.all.each do |mail|
  puts mail.multipart?          #=> true
  puts mail.parts.length        #=> 2
  puts mail.preamble            #=> "Text before the first part"
  puts mail.epilogue            #=> "Text after the last part"
  puts mail.parts.map { |p| p.content_type }  #=> ['text/plain', 'application/pdf']
  puts mail.parts.map { |p| p.class }         #=> [Mail::Message, Mail::Message]
  puts mail.parts[0].content_type_parameters  #=> {'charset' => 'ISO-8859-1'}
  puts mail.parts[1].content_type_parameters  #=> {'name' => 'my.pdf'}
end