# Расапечатывает тексты и переводы всех песен исполнителя с сайта amalgama-lab.com

require 'open-uri'
require 'nokogiri'

# адрес сайта
# Адриано Челентано
url_addr = "https://www.amalgama-lab.com/songs/a/adriano_celentano/"



# получаем документ целиком в переменную doc
html = URI.open(url_addr)
doc = Nokogiri::HTML(html)

# Вывод в консоль, в процессе получения информации
console_print = true

# Сюда заносим результат
sng = []

# перебор элементов по css selector:
sg = doc.css('#songs_nav>ul>ul>li')
sg.each do |song|
  a_tag = song.css('a')
  song_href = a_tag.at_css('a')['href']
  song_name = a_tag.text

  # вывод в консоль
  if console_print
    puts "_______________________________________________________"
    print "|       ",song_name
    puts
    puts "_______________________________________________________"
  end

  # полный одрес песни
  song_full_href = url_addr + song_href
  song_doc = Nokogiri::HTML(URI.open(song_full_href))

  # текст всей песни с переводом
  txt=[]


  #перебор строк песни
  sng_doc = song_doc.css('#click_area > div.string_container')
  sng_doc.each do |song_line|
    text_original = song_line.at_css('div.original').text
    text_rus      = song_line.at_css('div.translate').text

    # вывод в консоль
    if console_print
      print text_original," - ", text_rus
      puts
    end

    # Массив с текстом песни: каждый элемент - ХЕШ: оригинал, перевод
    txt<<  {
      original:text_original,
      translated: text_rus}
  end
  # Песня целиком - название и текст (массив строк)
  sng << {
    name: song_name,
    text: txt
  }
end
# Конец программы