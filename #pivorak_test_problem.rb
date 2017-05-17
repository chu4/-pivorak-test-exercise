require 'yaml'

class Admin
  def initialize(username, password, buses)
    @username = username
    @password = password
    @buses = buses
  end

  def add_route(id, num_s, start, start_date, start_time, finish, finish_time)
    seat_matrix = Array.new
    @buses[id]=[start_date, start, finish, start_time, finish_time, num_s, Hash.new, seat_matrix]
    return @buses
  end

  def add_mid_stops(id)
    puts "Enter city the bus stops at."
    stop = gets.chomp
    puts "Enter time bus arrives at #{stop}."
    stop_time = gets.chomp
    @buses[id].push([stop, stop_time])
    return @buses
  end

  def update

  end

  def delete(id)
    @buses.delete(id)
    return @buses
  end

  def check_sales(id)
    @buses[id][6].each {|k,v| puts "User #{k} bought #{v} tickets for the bus #{id} on  #{@buses[id][0]} from #{@buses[id][1]} to #{@buses[id][2]}"}
    return nil
  end
end

class User
  def initialize
  end
end

#loads logins and passwords of admins from file into a hash
admin = YAML.load_file('admin.yml')

#loads logins and passwords of users from a file into a hash
user = YAML.load_file('user.yml')

#loads existing bus routes from the file, if none exists creates empty Hash
buses = YAML.load_file('buses.yml')
if buses == false
  buses = Hash.new
end


puts admin,user

def show_routes(buses) #helper function to show existing bus routes
  buses.each do |k,v|
    puts "Route #{k} #{buses[k][1]} - #{buses[k][2]} on #{buses[k][0]} #{buses[k][3]}-#{buses[k][4]} number of available seats #{buses[k][5]}"
    if buses[k].length>8
      puts "    Goes through:"
      buses[k][8..-1].each do |mid_stop|
        puts "        #{mid_stop[0]} arrives at #{mid_stop[1]} "
      end
    end
  end
  puts nil
  return nil
end

def continue_fun(cont,buses) #helper function: to check if user wants to continue working
  while cont !="yes" && cont!="no"
    puts "If you want to continue working enter 'yes', else enter 'no'."
    cont = gets.chomp
    puts cont
    if cont == 'yes'
      return 0
    elsif cont == 'no'
      File.write('buses.yml', buses.to_yaml) #after work done writes the result of all work to the file
      return 1
    else
      puts "Invalid entry"
    end
  end
end

puts "Do you want to login or register?" #type in login or register
first_entry = gets.chomp

case first_entry
when "login"  #case of logining
  login = nil
  while login == nil
    puts "Enter login:"
    login1 = gets.chomp
    puts "Enter password:"
    pass = gets.chomp
    if admin.key?(login1.to_sym) && pass == admin[login1.to_sym] then  #checking if the login and password are in admin hash
      login = login1
      puts "Welcome admin #{login1}"

      admin = Admin.new(login, pass, buses)

      entry = 0
      while entry == 0
        entry = 1

        puts "Enter 'add' to add new route."
        puts "Enter 'update' to update existing route."
        puts "Enter 'delete' to delete existing route."
        puts "Enter 'check' to check the sales on existing route."
        puts "Enter 'quit' to quit the application."

        admin_entry1 = gets.chomp
        puts admin_entry1

        case admin_entry1
        when "add"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of a new bus route."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              puts "This ID already exists."
            else
              id = id1
            end
          end


          puts "Enter the starting city of the route."
          start = gets.chomp
          puts "Enter the departure date(DD.MM.YYYY)"
          start_date = gets.chomp
          puts "Enter the departure time(HH:MM)"
          start_time = gets.chomp
          puts "Enter the last city of the route."
          finish = gets.chomp
          puts "Enter the arrival time(HH:MM)"
          finish_time = gets.chomp

          num_s = nil
          until num_s.is_a?(Fixnum) do #checks if the input is integer
            puts "Enter the number of seats in the bus."
            num_s = Integer(gets.chomp)
          end

          buses = admin.add_route(id, num_s, start, start_date, start_time, finish, finish_time)  #sets the hash[ID] to list of entered info from admin class

          admin_entry2 = nil
          until ['yes','no'].include? admin_entry2 do #checks if input is either 'yes' or 'no'
            puts "Are there other stops on the route. Enter 'yes' or 'no'."
            admin_entry2 = gets.chomp

            case admin_entry2
            when 'yes'
              num_stops = nil
              until num_stops.is_a?(Fixnum) do #checks if the input is integer
                puts "How many middle stops are in the route?"
                num_stops = Integer(gets.chomp)
              end

              num_stops.times do #promts admin to enter num_stops middle stops
                buses = admin.add_mid_stops(id)#add stop to the route list in hash[ID]

              end
            when 'no'
              break
            else
              puts "Invalid entry."
            end
          end

          puts "added"
          cont = 0
          entry = continue_fun(cont,buses)
        when "update"
          show_routes(buses)

          puts "Enter the id of a bus route to be updated."
          puts "updated"
          cont = 0
          entry = continue_fun(cont,buses)
        when "delete"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of a bus route to be deleted."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
            else
              puts "This ID does not exist."
            end
          end
          buses = admin.delete(id)
          puts "deleted"
          cont = 0
          entry = continue_fun(cont,buses)
        when "check"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of a bus route to check it's sold tickets."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
            else
              puts "This ID does not exist."
            end
          end

          puts admin.check_sales(id)
          puts "checked"
          cont = 0
          entry = continue_fun(cont,buses)
        when "quit"
          puts "Quitting.."
        else
          puts "Invalid entry"
          entry = 0
        end
      end

    elsif user.key?(login1.to_sym) && pass == user[login1.to_sym] then  #checking if login and password are in user hash
      login = login1
      puts "Welcome user #{login1}"

      #initialize user class

      entry = 0
      while entry == 0
        entry = 1

        puts "Enter 'check' to check the bus routes."
        puts "If you know the ID of the bus route you wish, enter 'buy' to buy a ticket."
        puts "Enter 'tickets' to check purchased tickets."
        puts "Enter 'quit' to quit the application."

        user_entry1 = gets.chomp

        case user_entry1
        when "check"
          show_routes(buses)
          puts "Enter the city you're interested in:"
          city = gets.chomp
          #check if city exists
          puts "Enter the date you're interested in(in this form DD.MM.YYYY):"
          date = gets.chomp
          #check if date exists

          puts "Filtered buses"
          cont = 0
          entry = continue_fun(cont,buses)
        when "buy"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of desired bus route."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
            else
              puts "This ID does not exist."
            end
          end

          puts "Seats available" #list of seats available for the ID route
          seat = nil
          until seat.is_a?(Fixnum) do #checks if the input is integer
            puts "Choose available seat, and enter it's number."
            seat = gets.chomp
          end
          puts "You bought seat ##{seat}. Thank you for the purchase."
          cont = 0
          entry = continue_fun(cont,buses)
        when "tickets"

          puts "Your tickets"
          cont = 0
          entry = continue_fun(cont,buses)
        when "quit"
          puts "Quitting.."
        else
          puts "Invalid entry"
          entry = 0
        end
      end

    else
      puts "Login and/or password are not right." # in case of either wrong login or password prompts user to re-enter them
    end
  end



when "register"           #case of registering (it is only possible to register regular user
  while login == nil      #not an admin). prompting user to enter correct login
    puts "Enter login:"
    login1 = gets.chomp

    if admin.key?(login1.to_sym) || user.key?(login1.to_sym) then #checks if login name is
      puts "This login is already used"                           #occupied.
    else
      login = login1
    end
  end
  while pass == nil                     #checking if both entered passwords are similar before saving them in hash.
    puts "Enter password:"              #prompting user to enter two similar passwords
    pass1 = gets.chomp
    puts "Enter password one more time:"
    pass2 = gets.chomp

    if pass1==pass2 then
      pass=pass1
    else
      puts "passwords don't match"
    end
  end
  user[login.to_sym] = pass #saving new user in user.hash
  File.write('user.yml', user.to_yaml)
else
  puts "invalid entry" # if the user didnt enter login nor register
end
