require 'yaml'

class Admin
  def initialize(username, password, buses)
    @username = username
    @password = password
    @buses = buses
  end

  def add_route(id, num_s, start, start_date, start_time, finish, finish_time)
    seat_array = (1..num_s).to_a
    @buses[id]=[start_date, start, finish, start_time, finish_time, num_s, Hash.new, seat_array]
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
  def initialize(username, password,buses,tickets)
    @username = username
    @password = password
    @buses = buses
    @tickets = tickets
  end

  def check(city, date)
    filtered_buses = Hash.new
    @buses.each do |k,v|
      if v[0]==date && v[1]==city
        filtered_buses[k]=v
      end
    end
    return filtered_buses
  end

  def buy(id,seat)
    @buses[id][7][@buses[id][7].index(seat)] = "_"
    @buses[id][6].default=0
    @buses[id][6][@username.to_sym]+=1
    @buses[id][5]-=1

    check = false # checks if user had already bought a ticket for this route
    @tickets[@username.to_sym].each do |k|
      if k[0]==id
        check = true
        k[1]+=1   #add another ticket to the already bought one(s)
      end
    end
    if check == false #if user havent bought ticekts for this route
        @tickets[@username.to_sym].push([id, 1]) #adds new record of bought tickets
    end

    return @buses, @tickets
  end

  def tickets(login)

    return @tickets[login.to_sym]
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

#loads the information of purchased tickets of all users
tickets = YAML.load_file('tickets.yml')
if tickets == false
  tickets = Hash.new
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

def continue_fun(cont,buses,tickets) #helper function: to check if user wants to continue working
  while cont !="yes" && cont!="no"
    puts "If you want to continue working enter 'yes', else enter 'no'."
    cont = gets.chomp
    puts cont
    if cont == 'yes'
      return 0
    elsif cont == 'no'
      File.write('buses.yml', buses.to_yaml) #after work done writes the results of all work to the files
      File.write('tickets.yml', tickets.to_yaml)
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
          entry = continue_fun(cont,buses,tickets)

        when "update"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of a bus route to be updated."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
              if buses[id][6] == {}

                #buses = admin.update(id)

                puts "updated"
              else
                puts "You can't update this route because there are tickets being purchased already."
              end
            else
              puts "This ID does not exist."
            end
          end

          cont = 0
          entry = continue_fun(cont,buses,tickets)

        when "delete"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of a bus route to be deleted."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
              if buses[id][6] == {}
                buses = admin.delete(id)
                puts "deleted"
              else
                puts "You can't delete this route because there are tickets being purchased already."
              end
            else
              puts "This ID does not exist."
            end
          end

          cont = 0
          entry = continue_fun(cont,buses,tickets)
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
          entry = continue_fun(cont,buses,tickets)
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

      user = User.new(login, pass, buses, tickets)

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

          exists = false #checks if there are city and date that are equal to entered values
          while exists == false
            puts "Enter the city you're interested in:"
            city = gets.chomp
            puts "Enter the date you're interested in(in this form DD.MM.YYYY):"
            date = gets.chomp

            buses.each do |k, v|
              if v[0]==date && v[1]==city
                exists = true
              end
            end

            if exists == true
              filtered = user.check(city, date)
              puts "Buses we found for you"
              show_routes(filtered)
            else
              user_entry3 = nil
              until user_entry3=="yes" || user_entry3=="no"
                puts "There are no buses from #{city} on #{date}"
                puts "Do you want to try again?('yes' or 'no')"
                user_entry3 = gets.chomp
              end
              if user_entry3 == "no"
                break
              end
            end
          end
          cont = 0
          entry = continue_fun(cont,buses,tickets)
        when "buy"
          show_routes(buses)

          id = nil
          while id==nil  #checks if ID is in the buses hash
            puts "Enter the ID of desired bus route."
            id1 = gets.chomp.to_sym
            if buses.key?(id1) == true
              id = id1
              if buses[id][5]!=0 #checks if there are any seats available on ID bus
                puts "Seats available" #list of seats available for the ID route

                buses[id][7].each do |el| #prints out list of available seats. 4 per row
                  if el%4==0
                    puts el
                  else
                    print el," "
                  end
                end

                seat = nil
                until seat.is_a?(Integer) && buses[id][7].include?(seat) do #checks if the     input is integer and if it is available in the seat_array
                  puts "Choose available seat, and enter it's number."
                  seat = Integer(gets.chomp) rescue false
                end

                buses, tickets = user.buy(id, seat)

                puts "You bought seat ##{seat}. Thank you for the purchase."
              else
                puts "No seats available on this bus."
              end
            else
              puts "This ID does not exist."
            end
          end

          cont = 0
          entry = continue_fun(cont,buses,tickets)
        when "tickets"
          puts "Your tickets"
          tickets=user.tickets(login)

          tickets.each do |bus|
              puts "You have #{bus[1]} ticket(s) for the bus #{bus[0]} #{buses[bus[0]][1]} - #{buses[bus[0]][2]} on #{buses[bus[0]][0]} #{buses[bus[0]][3]}-#{buses[bus[0]][4]}"
          end
          cont = 0
          entry = continue_fun(cont,buses,tickets)
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
