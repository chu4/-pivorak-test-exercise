require 'yaml'

#loads logins and passwords of admins from file into a hash
admin = YAML.load_file('admin.yml')

#loads logins and passwords of users from a file into a hash
user = YAML.load_file('user.yml')

puts admin,user

def continue_fun(cont) #helper function: to check if user wants to continue working
  while cont !="yes" && cont!="no"
    puts "If you want to continue working enter 'yes', else enter 'no'."
    cont = gets.chomp
    puts cont
    if cont == 'yes'
      return 0
    elsif cont == 'no'
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

      entry = 0
      while entry == 0
        entry = 1

        puts "Enter 'add' to add new route."
        puts "Enter 'update' to update existing route."
        puts "Enter 'delete' to delete existing route."
        puts "Enter 'check' to check the sales on existing route."
        puts "Enter 'quit' to quit the application."

        admin_entry = gets.chomp
        puts admin_entry

        case admin_entry
        when "add"
          #puts $buses
          puts "Enter the id of a new bus route."
          puts "added"
          cont = 0
          entry = continue_fun(cont)
        when "update"
          #puts $buses
          puts "Enter the id of a bus route to be updated."
          puts "updated"
          cont = 0
          entry = continue_fun(cont)
        when "delete"
          #puts $buses
          puts "Enter the id of a bus route to be deleted."
          puts "deleted"
          cont = 0
          entry = continue_fun(cont)
        when "check"
          #puts $buses
          puts "Enter the id of a bus route to check it's sold tickets."
          puts "checked"
          cont = 0
          entry = continue_fun(cont)
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
          #puts $buses
          puts "Enter the city you're interested in:"
          city = gets.chomp
          puts "Enter the date you're interested in(in this form DD.MM.YYYY):"
          date = gets.chomp
          puts "Filtered buses"
          cont = 0
          entry = continue_fun(cont)
        when "buy"
          #puts $buses
          puts "Enter the ID of desired bus route."
          id = gets.chomp
          id = id.to_sym
          puts id

          puts "Seats available"
          puts "Choose available seat, and enter it's number."
          seat = gets.chomp
          puts "You bought seat ##{seat}. Thank you for the purchase."
          cont = 0
          entry = continue_fun(cont)
        when "tickets"
          puts "Your tickets"
          cont = 0
          entry = continue_fun(cont)
        when "quit"
          puts "Quitting.."
        else
          puts "Invalid entry"
          entry = 0
        end
      end

    else
      puts "Login and/or password are not right." # in case of either wrong login or password promts user to re-enter them
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
