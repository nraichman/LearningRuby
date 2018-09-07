require "./components.rb"

class Room

  def initialize(engine)
    @engine = engine
    @visited = false
  end

  attr_accessor :visited
end

class Death < Room

  def enter()
    puts "You've failed... Better luck next time."
    exit(1)
  end
end


class  Cellar < Room

  def enter()
    puts """ You wake up in a dark cellar. It seems like you have been sleeping
    for a while. Maybe you were knocked out. You can't remember. Your head hurts.
      Suddenly your hearing comes back to you, and you are overwhelmed by the commotion.
      It's a prison break. Convicts are running out, and guards are yelling and chasing after them.
      You look around and you see that your door is open too. But you hear the guards coming.
      Should you run? You also notice that there is a wide crack in the wall.
      Hurry! You hear the guards coming. You must make a decision. Will you run away?

      1. Attempt escape
      2. Wait and do nothing
      >
      """

      action = $stdin.gets.chomp

      if action == '1'
        puts """ You manage to escape the prison with a swarm of other convicts.
        As you leave the castle you stray away fro mthe group and into the forest
        to hide. You walk for a few hours until you get tiered. You stop at a clearence in the dark forest.
        Your safe. For now.
        """
        return 'Forest'
      elsif action == '2'
        puts """ The guard comes to your cell and locks the door on you.
        You rot in prison.
        """
        return 'Death'
      else
        puts """ You try something impossible. And nothing happens.
        You rot in prison.
        """
        return 'Death'
      end
    end
  end

  class Forest < Room

    def enter()
      puts """ As you get to the forest clearence, night is about to fall.
      You look around you and you see a crooked path to the east, a river flowing down south,
      and a small rabbit hole in the ground. You contemplate on whether you should keep going tonight.
      What will you do?
      1. go east
      2. go south
      3. try to jump into the rabbit hole
      4. make camp and sleep
      >
      """

      action = $stdin.gets.chomp

      if action == '1'
        puts "You follow the path to the east, and the forest keeps getting thicker and thicker as you go forward..."
        return 'Hut'
      elsif action == '2'
        puts """You follow the river to the south. As you move forward the forest clears out, and you see the ocean in the horizon."
        return 'Cliff'
      elsif action == '3' && @engine.player.has_item('potion')
        puts """You drink your potion and it shrinks you to the size of a small rabbit.
        You then proceed to jump into the rabbit hole."""
        return 'Gate'
      elsif action == '4'
        puts """ You make camp and are attacked by a swarm of bandits. The slay you in your sleep."
        return 'Death'
      else
        puts """ You try something impossible. And nothing happens.
        You die of frustration.
        """
        return 'Death'
      end
    end
  end

  class Hut < Room

    def enter()
      puts """You arrive at a hut in the middle of the forest. The light is on, and the chimney is smoking.
      Someone is home. You knock on the door, and a small old lady answers. She greets you with a warm smile, and offers you stay for a while.
      You go in and sit down. The old lady tells you she knows she knows your name. #{@engine.player.name}. She knows you escaped from prison, and she tells you
      that the only way you can regain your freedom is by finding the golden chalice. The legendary chalice could win you fame and fortune that will make the king forgive you for your crimes.
      But first, you must help the old lady make some soup. For that, she needs a vulture's beak, or a mans heart...

      1. You agree to help her get the beak.
      2. You tell her she is crazy.
      3. You run away
      """

      action = $stdin.gets.chomp

     if action == '1' && @engine.player.has_item('beak')
       puts "The old lady laughs frantically as she throws the beak into the pot. You fall asleep... When you wake up, you are alone with the potion in your hand. You march back to the forest"
       return 'Forest', 'potion'
     elsif action == '1'
        puts "You agree to help her, and she lets you go. You better come back with the beak"
        return 'Forest', 'bow'
      elsif action == '2'
        puts "You tell her she's crazy... She quickly stabs you and grabs a hold of your heart. What were you thinking?!"
        return 'Death'
      elsif action == '3'
        puts "You attempt to run away, but as you run, the road seems to be leading you back to her house. No matter what you do, you end up at the old lady's door step"
        return 'Hut'
      else
        puts """ You try something impossible. And nothing happens.
        You die of the flu.
        """
        return 'Death'
      end
    end
  end

  class Cliff < Room

    def enter()
      puts """ You arrive at a cliff looking at the vast ocean below. The water shatter as they fall on the sarp rocks.
      A vulture is soaring above. What do you do?

      1. You jump of the cliff.
      2. You attempt to hunt the vulture.
      3. You set camp.
      4. Go back
      >
      """

      action = $stdin.gets.chomp

      if action == '1'
        puts "..."
        return 'Death'
      elsif action == '2' && @engine.player.has_item('bow')
        puts "You snipe the vulture right in the heart. The vulture falls down and you collect its beak."
        return 'Cliff', 'beak'
      elsif action == '2'
        puts "You throw a rock at the vulture, but miss. It comes down and attacks you with its razor sharp talons. You die of infection a few days later"
        return 'Death'
      elsif action == '3'
        puts "You sit by the fire and ponder about life."
        return 'Cliff'
      elsif action == '4'
        puts "You march back into the forest..."
        return 'Forest'
      else
        puts """ You try something impossible. And nothing happens.
        You die of dehydration.
        """
        return 'Death'
      end
    end
  end

  class Gate < Room

    def enter()
      puts """ As you get out of the rabbit hole from the other side, you fall into a room. It is smelly. It smells like a dog.
      You look up and you see a huge three headed dog sleeping.

      1. You sneak by it.
      2. You attempt to pet it.
      3. You try to climb back up the rabit hole.
      >
      """

      action = $stdin.gets.chomp

      if action == '1'
        puts "The dog wakes up and rips you into shreds."
        return 'Death'
      elsif action == '2'
        puts "The dog wakes up and flips on its back, wiggling its tail. You grab the keys off of its neck and open the door. You shut the door behind you quickly as soon as you are through."
        return 'Final'
      elsif action == '3'
        puts "rabbit holes are one way..."
        return 'Gate'
      else
        puts """ You try something impossible. And nothing happens.
        You die from the smell.
        """
        return 'Death'
      end
    end
  end

  class Final < Room

    def enter()
      puts """Congradulations! You found the chalice! You are now a free man!"""
    end
  end
