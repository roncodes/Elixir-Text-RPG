# Engine - Manage input, output
defmodule Engine do

	def prompt(text) do
		IO.gets text
	end

	def echo(text) do
		IO.puts text
	end

	def cointoss do
		number = :random.uniform(10)
		if number > 5 do
			true
		else
			false
		end
	end

end

# Battle - Handles battles
defmodule Battle do

	def init(player, opponent) do
		# let's see who's move it is first... cointoss!
		if Engine.cointoss do
			# if heads (true) player goes first
			Engine.echo("You\'re up first!")
			turn = 1
		else
			# if tails opponent goes first
			Engine.echo("Opponent moves first!")
			turn = 0
		end
		Battle.move(player, opponent, turn)
	end

	def move(player, opponent, turn) do
		Engine.echo("\n======== " <> player.name <> " versus " <> opponent.name <> " ========\n" <> player.name <> " HP: " <> (to_string player.health) <> "\n" <> opponent.name <> " HP: " <> (to_string opponent.health) <> "\n")
		if turn == 1 do
			# players go
			playerMove = Engine.prompt("Choose your move: (Attack or Defend): ")
			if playerMove == "Attack\n" do
				Battle.attack(player, opponent, turn)
			else
				Battle.defend(player, opponent, turn)
			end
		else 
			# opponents turn
			if Engine.cointoss do
				# if heads (true) opponent will attack
				Battle.attack(opponent, player, turn)
			else 
				# if tails opponent will defend
				Battle.defend(opponent, player, turn)
			end
		end 
	end

	def attack(attacker, victim, turn) do
		Engine.echo(attacker.name <> " attacks " <> victim.name <> " for " <> (to_string attacker.attack) <> " points of damage!")
		victim = Map.put(victim, :health, (victim.health-attacker.attack))
		if victim.health <= 0 do
			Battle.over(attacker, victim)
		end
		# who is the attacker ?
		if turn == 1 do
			# player was attacker
			Battle.move(attacker, victim, 0)
		else 
			# opponent was attacker
			Battle.move(victim, attacker, 1)
		end
	end

	def defend(defender, nonDefender, turn) do
		defenseGain = (defender.level*2)
		Engine.echo(defender.name <> " gains " <> (to_string defenseGain) <> " health points in defense!")
		# defense just increases the defenders health by 2*level
		defender = Map.put(defender, :health, (defender.health + defenseGain))
		# who is the defender ?
		if turn == 1 do
			# player was defender
			Battle.move(defender, nonDefender, 0)
		else 
			# opponent was defender
			Battle.move(nonDefender, defender, 1)
		end
	end

	def over(player, opponent) do
		if player.health > opponent.health do
			Engine.echo(player.name <> " wins the battle!")
		else 
			Engine.echo(opponent.name <> " wins the battle!\n You lose!")
		end
		Game.menu(player)
	end

end

# Player class
defmodule Player do

	def create do
		%{:name => "", :class => "Warrior", :level => 1, :attack => 5, :health => 100}
	end

	def update(player, key, value) do
		Map.put(player, key, value)
	end

end

# Actual game
defmodule Game do

	def start do
		go = Engine.prompt("Ready to start game? (Yes or No): ")
		if go == "Yes\n" do
			Game.go
		else
			Game.start
		end
	end

	def go do
		player = %{:name => "", :class => "Warrior", :level => 1, :attack => 5, :health => 100}
		player = Map.put(player, :level, 5)
		characterName = Engine.prompt("Enter a character name: ")
		if characterName do
			player = Map.put(player, :name, String.strip(characterName))
			Engine.echo("Welcome to the world of Battle Lords " <> player.name)
		end
		Game.menu(player)
	end

	def menu(player) do 
		action = Engine.prompt("Choose your action: (Battle or Stats): ")
		if action == "Battle\n" do
			Game.startBattle(player)
		else action
			Engine.echo("\nCharacter Name: " <> player.name <> "\nClass: " <> player.class <> "\nLevel: " <> (to_string player.level) <> "\nAttack: " <> (to_string player.attack) <> "\nHealth: " <> (to_string player.health))
		end
		Game.menu(player)
	end

	def startBattle(player) do
		opponent = %{:name => "Crusader", :class => "Dark Knight", :level => 1, :attack => 5, :health => 100}
		Engine.echo("You are about to enter battle against the " <> opponent.name)
		Battle.init(player, opponent)
	end
end

# Start the game
Game.start