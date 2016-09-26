require 'nokogiri'

class HitSolver
  def initialize(puzzle)
    doc = Nokogiri.XML("<data>#{puzzle.data}</data>")
    root = doc.root
    dimension = (root>"dimensions").first
    @w, @h = dimension['width'].to_i, dimension['height'].to_i
    @difficulty = puzzle.properties.where(:name => "difficulty").first.value
    puts "#{@w}x#{@h} difficulty #{@difficulty}"
    @src = (root>"source").first.text.split.in_groups(@h)
    @solution = (root>"solution").first.text.split
    @sol = ([-1] * (@w*@h)).in_groups(@h)
    @steps = []
    @actions = []
  end

  def solve
    startup()
    progress = true
    while progress
      progress = false
      for m in @@methods
        if self.send(m)
          progress = true
          break
        end
      end
    end
    puts "Final: #{@sol}"
    puts "Steps: #{@steps}"
    if @sol.flatten == @solution
      puts 'Solved!'
    else
      puts 'Failed!'
    end
  end

  private

  def startup
    for i in 0..@h-1
      for j in 1..@w-2
        if @src[i][j-1] == @src[i][j+1] and @sol[i][j] == -1
          @sol[i][j] = 0
          @steps.push [i, j, 0]
          @actions.push [i, j, 0]
        end
      end
    end
    for i in 1..@h-2
      for j in 0..@w-1
        if @src[i-1][j] == @src[i+1][j] and @sol[i][j] == -1
          @sol[i][j] = 0
          @steps.push [i, j, 0]
          @actions.push [i, j, 0]
        end
      end
    end
  end

  def basic
    if @actions.empty?
      false
    else
      while not @actions.empty?
        x, y, v = @actions.pop
        if v == 0
          for i in 0..@h-1
            if i != x and @src[i][y] == @src[x][y] and @sol[i][y] == -1
              @sol[i][y] = 1
              @steps.push [i, y, 1]
              @actions.push [i, y, 1]
            end
          end
          for j in 0..@w-1
            if j != y and @src[x][j] == @src[x][y] and @sol[x][j] == -1
              @sol[x][j] = 1
              @steps.push [x, j, 1]
              @actions.push [x, j, 1]
            end
          end
        else
          for i, j in [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
            if i >= 0 and i < @h and j >= 0 and j < @w and @sol[i][j] == -1
              @sol[i][j] = 0
              @steps.push [i, j, 0]
              @actions.push [i, j, 0]
            end
          end
        end
      end
      true
    end
  end

  @@methods = [:basic]
end
