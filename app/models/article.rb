class Article < ActiveRecord::Base
validates :title, presence: true,
length: { minimum: 5 }
validates :content, presence: true,
length: { minimum: 10 }
has_attached_file :photo, :styles => { :medium => "600x600>", :thumb => "180x180>" }, :default_url => "/images/:style/missing.png"
validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
has_many :comments, dependent: :destroy
paginates_per 10

#action make data in show view become xlsx file
def to_xls
  p = Axlsx::Package.new
  ws = p.workbook.add_worksheet(:name => "Basic Worksheet")
  for n in 0..99 do
    ws.add_row [nil,nil,nil,nil]
  end
    ws.rows[0].cells[0].value =  "Artikel"
    ws.rows[1].cells[0].value =  "Judul"
    ws.rows[1].cells[1].value = "Isi"
    ws.rows[2].cells[0].value = self.title
    ws.rows[2].cells[1].value = self.content
    ws.rows[1].cells[2].value =  "Komentar"
    row= 2
    cell= 2
    self.comments.each do |comment|
      ws.rows[row].cells[cell].value = comment.content
      row += 1
    end
  p.use_shared_strings = true
  judul = "articles_"+self.title+".xlsx"
  p.serialize(judul)
end

#check file input and open it
def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

#action to import data from xlsx file
def self.import(file)
  debugger
  spreadsheet = open_spreadsheet(file)
  debugger
  @article = Article.new(title:spreadsheet.cell(3,1), content:spreadsheet.cell(3,2))
  @article.save
  isi = "ada"
  n = 3
  while isi!=nil do
    isi=spreadsheet.cell(n,3)
    comment = @article.comments.new
    comment.content = isi
    comment.save
    n+=1
    isi=spreadsheet.cell(n,3)
  end
end

#action make data in show view become pdf file
def to_pdf
  judul = self.title
  isi = self.content
  komentar = self.comments
  photo = self.photo
  pdftitle = "Article "+judul+".pdf"
  Prawn::Document.generate(pdftitle) do
    text judul, :align => :center, :size =>18
    move_down(20)
    image "#{photo.path(:medium)}"
    move_down(20)
    text isi
    move_down(10)
    text "Komentar"
    komentar.each do |comment|
      text "- "+ comment.content
    end
  end
end

end
