require "./rooms.rb"
class Engine

  def initialize(player_name)
    @scene_map = Map.new(self)
    @player = Player.new(player_name)
  end

  attr_reader :player

  def play()
    current_scene = @scene_map.opening_scene()
    last_scene = @scene_map.next_scene('Final')

    while current_scene != last_scene
      next_scene_name, item = current_scene.enter()
      if item != nil
        @player.add_item(item)
      end
      current_scene = @scene_map.next_scene(next_scene_name)
    end

    current_scene.enter()
  end
end

class Map

  def initialize(engine)
    @start_scene = 'Cellar'
    @engine = engine
    @scenes = {
      'Cellar' => Cellar.new(@engine),
      'Forest' => Forest.new(@engine),
      'Hut' => Hut.new(@engine),
      'Cliff' => Cliff.new(@engine),
      'Death' => Death.new(@engine),
      'Gate' => Gate.new(@engine),
      'Final' => Final.new(@engine),
    }
  end


  def next_scene(scene_name)
    val = @scenes[scene_name]
    return val
  end

  def opening_scene()
    return next_scene(@start_scene)
  end
end

class Player

  def initialize(name)
    @name = name
    @items = []
  end

  attr_reader :name

  def add_item(item)
    @items << item
  end

  def has_item(item)
    return @items.include? item
  end
end
