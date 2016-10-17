require "mechanize"
require 'launchy'

def main()
	num = 1
	address = []
	code = []
	urls = []

	agent = Mechanize.new
	agent.user_agent_alias = 'Mac Safari'
	agent.get("https://www.portalinmobiliario.com/arriendo/departamento/santiago-metropolitana?pg=1") do |page|
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
		  urls << "#{code[i]}-#{address[i]}-uda"
		end
		set_data(urls)
	end

	def set_data(urls)
		selector_address = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-right-col > div.property-data-sheet.clearfix > div.data-sheet-column.data-sheet-column-address > p > span:nth-child(1)"
		selector_bedroom = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-right-col > div.property-data-sheet.clearfix > div.data-sheet-column.data-sheet-column-programm > p"
		selector_description = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-right-col > div.row > div > div"
		selector_surface = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-right-col > div.property-data-sheet.clearfix > div.data-sheet-column.data-sheet-column-area > p"
		selector_service = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-left-col > div.propiedad-ficha-mini > div.row > div > div > p"
		selector_lessor = "#wrapper > section > div > div > div.col-sm-9.span-fix-content > article > div > div.propiedad-ficha.clearfix > div.content-left-col > div.content-panel > p > span"
		selector_price = "#wrapper > div > div > div > div.col-sm-3.price-badge-holder > div > span.price-reference"

		num = 0
		agent = Mechanize.new
		agent.user_agent_alias = 'Mac Safari'
		for i in 0..25
			agent.get("https://www.portalinmobiliario.com/arriendo/departamento/santiago-metropolitana/#{urls[i]}") do |page|
				puts "**********************************************************"
				puts page.parser.css(selector_address).text
				puts "---------------"
				puts page.parser.css(selector_bedroom).text
				puts "---------------"
				puts page.parser.css(selector_description).text.gsub(" ","")
				puts "---------------"
				puts page.parser.css(selector_surface).text
				puts "---------------"
				puts page.parser.css(selector_service).text
				puts "---------------"
				puts page.parser.css(selector_lessor).text
				puts "---------------"
				puts page.parser.css(selector_price).text
				puts "**********************************************************"
			end
		end
	end

	clear_string(code, address)
	set_urls(code,address)
end

main()



