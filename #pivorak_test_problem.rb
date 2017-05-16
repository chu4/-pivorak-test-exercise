require 'yaml'

#loads logins and passwords of admins from file into a hash
admin = YAML.load_file('admin.yml')

#loads logins and passwords of users from a file into a hash
user = YAML.load_file('user.yml')

puts admin,user

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
    elsif user.key?(login1.to_sym) && pass == user[login1.to_sym] then  #checking if login and password are in user hash
      login = login1
      puts "Welcome user #{login1}"
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
