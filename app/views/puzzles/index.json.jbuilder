json.page @page
json.per_page @perPage
json.total @total
json.puzzles do
  json.array! @puzzles, partial:'puzzles/puzzle', as: :puzzle
end
