class RobotSimulation
	@@direction = ['NORTH', 'EAST', 'SOUTH', 'WEST']

	def initialize
		@@position = {}
		@@first_run = true
		RobotSimulation.wait_cmd
	end

	def self.read_commands(cmd)
		command = cmd.split(' ')
		command.shift
		arr_cmd = []
		dir = command.join(' ')
		i = 0
		cur_dir = File.expand_path(File.dirname(__FILE__))
		File.open(cur_dir+"/"+dir, "r") do |f|
			f.each_line do |line|
				puts "Command from file = #{line}"
				self.wait_cmd(line)
				i+=1
			end
		end

	end
	def self.wait_cmd(cmd=nil)
		if @@first_run
			if cmd
				command = cmd
			else
				puts "Input starting point using this command PLACE x,y,DIRECTION. \nAlternatively you may use READ for file execution \n(Type HELP for the command list or QUIT to terminate application)"
				command = gets.chomp
			end
			if command.upcase.start_with?('READ')
				self.read_commands(command)
			elsif command.upcase.start_with?('QUIT')
				return puts 'Thank for playing with me!'
			else
				self.place_robot(command)
			end
		else
			if cmd
				command = cmd
			else
				puts 'Input Command(Type HELP for the command list or QUIT to terminate application):'
				command = gets.chomp
			end
			if command.upcase.start_with?('HELP')
				cur_dir = File.expand_path(File.dirname(__FILE__))
				File.open(cur_dir+"/help.txt", "r") do |f|
					f.each_line do |line|
						puts line
					end
				end
			elsif command.upcase.start_with? 'PLACE'
				self.place_robot(command)
			elsif command.upcase.start_with?('READ')
				self.read_commands(command)
			elsif command.upcase.start_with?('MOVE')
				self.move
			elsif command.upcase.start_with?('REPORT')
				puts @@position
				puts 'COMMAND EXECUTED'
			elsif command.upcase.start_with?('LEFT') || command.upcase.start_with?('RIGHT')
				self.rotate(command)
			elsif command.upcase.start_with?('QUIT')
				@@position = {}
				return puts 'Thank for playing with me!'
			else
				puts 'INVALID COMMAND. Please use HELP to see list of available commands'
			end
		end
		self.wait_cmd if cmd.nil?
	end

	def self.place_robot(cmd)
		if cmd.split(' ').length != 2
			puts 'Invalid format e.g. PLACE 1,1,NORTH'
		else
			loc = cmd.split(' ')[1]
			loc = loc.split(',')
			if loc.length.eql? 0
				puts 'Invalid format e.g. PLACE 1,1,NORTH'
			else
				if !loc[0].to_i.between?(0,5)
					puts 'Invalid X-axis location. Please input a valid integer between 0 - 5'
				elsif !loc[1].to_i.between?(0,5)
					puts 'Invalid Y-axis location. Please input a valid integer between 0 - 5'
				elsif @@direction.find_index(loc[2].upcase).nil?
					puts 'Invalid direction. Please choose from NORTH, SOUTH, EAST OR WEST'
				else
					@@position['x'] = loc[0].to_i
					@@position['y'] = loc[1].to_i
					@@position['F'] = loc[2].upcase
					puts 'COMMAND EXECUTED'
					@@first_run = false if @@first_run
				end
			end
		end
	end

	def self.move		
		case @@position['F']
		when 'NORTH'
			if @@position['y'] >= 5
				puts 'COMMAND FAILED. Cannot move outside the board'
			else
				@@position['y']+= 1
			end
		when 'SOUTH'
			if @@position['y'] == 0
				puts 'COMMAND FAILED. Cannot move outside the board' 
			else
				@@position['y']-= 1
			end
		when 'EAST'
			if @@position['x'] >= 5
				puts 'COMMAND FAILED. Cannot move outside the board' 
			else
				@@position['x']+= 1
			end
		when 'WEST'
			if @@position['x'] == 0
				puts 'COMMAND FAILED. Cannot move outside the board'
			else
				@@position['x']-= 1
			end
		end
		puts 'COMMAND EXECUTED'
	end

	def self.rotate(cmd)
		cur_direction = @@direction.find_index(@@position['F'])
		if cmd.upcase.start_with?('LEFT')
			if cur_direction == 0
				@@position['F'] = @@direction[3]
			else
				@@position['F'] = @@direction[cur_direction-1]
			end
		else
			if cur_direction == 3
				@@position['F'] = @@direction[0]
			else
				@@position['F'] = @@direction[cur_direction+1]
			end
		end
		puts 'COMMAND EXECUTED'
	end
end