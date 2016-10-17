require "mechanize"
require 'launchy'

def main()
	num = 1
	address = []
	code = []
	urls = []

	agent = Mechanize.new
	agent.user_agent_alias = 'Mac Safari'
	agent.get("https://www.portalinmobiliario.com/arriendo/departamento/santiago-metropolitana?pg=2") do |page|
		25.times do
			address << page.parser.css("#wrapper > section.content-section.content-sidedar-equals > div > div > div.col-sm-9.span-fix-content > article > div.products-list > div:nth-child(#{num}) > div.col-sm-9.product-item-data > div > div.col-sm-6.product-item-summary > h4 > a").text
			code << page.parser.css("#wrapper > section.content-section.content-sidedar-equals > div > div > div.col-sm-9.span-fix-content > article > div.products-list > div:nth-child(#{num}) > div.col-sm-9.product-item-data > div > div.col-sm-6.product-item-summary > p:nth-child(3)").text

			num+=1
		end
	end

	def clear_string(code, address)
		replacements = [ [",", ""], [" -", ""], [" /", ""], ["-", ""], ["/", ""], [".", ""],[" santiago", ""] , 
											["santiago", ""], ["ñ", "n"],["á", "a"],["é", "e"],["í", "i"],["ó", "o"],["ú", "u"],
											["Ñ", "n"],["Á", "a"],["É", "e"],["Í", "i"],["Ó", "o"],["Ú", "u"],["'", ""],[" ", "-"] ]

		code.each{ |code| code.gsub!('Código: ','')}

		address.each{ |address| address.downcase! }

		replacements.each do |replacement| 
			address.each do |address| 
				address.gsub!(replacement[0], replacement[1])
			end
		end
	end

	def set_urls(code,address)
		urls = []
		for i in 0..25
		  urls << "#{i}: #{code[i]}-#{address[i]}-uda"
		end
		puts urls
	end

	clear_string(code, address)
	set_urls(code,address)

	#Launchy.open("https://www.portalinmobiliario.com/arriendo/departamento/santiago-metropolitana/#{urls[0]}")
end

main()



