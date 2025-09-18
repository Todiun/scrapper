require 'nokogiri'
require 'open-uri'

# Récupérer l'email d'une mairie
def get_townhall_email(url)
  page = Nokogiri::HTML(URI.open(url))
  email = page.at_xpath('//a[contains(@href, "mailto:")]')
  email ? email.text.strip : nil
end

# Récupérer les URLs des mairies du Val-d'Oise
def get_townhall_urls
  base_url = 'https://lannuaire.service-public.fr/navigation/ile-de-france/val-d-oise/mairie'
  page = Nokogiri::HTML(URI.open(base_url))

  # XPath vers tous les liens de mairie
  links = page.xpath('//*[@id="main"]/div/div/div/article/div[3]/ul/li/a')

  # Transformer en URLs complètes
  links.map { |link| { name: link.text.strip, url: 'https://lannuaire.service-public.fr' + link['href'] } }
end

# Construire le tableau de hashes ville => email
townhall_data = get_townhall_urls.map do |town|
  email = get_townhall_email(town[:url])
  { town[:name] => email } if email
end.compact

# Afficher le résultat
puts "Nombre de mairies récupérées : #{townhall_data.size}"
townhall_data.each { |town| puts town }

