pdf.text "Article", :size => 30, :style => :bold
pdf.move_down(30)

items = @article.comments.line_items.map do |item|
  [
    item.content
  ]
end

pdf.table items, :border_style => :grid,
  :row_colors => ["FFFFFF","DDDDDD"],
  :headers => ["Comment"],
  :align => {0 => :left}

  pdf.move_down(10)
