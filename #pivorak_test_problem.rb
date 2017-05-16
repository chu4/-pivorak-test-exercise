admin = {root: "123"}
user = {chu: "123", abc: "234"}

puts "Do you want to login or register?" #type in login or register
first_entry = gets.chomp

case first_entry
when "login"  #case of logining
  puts "Enter login:"
  login = gets.chomp
  puts "Enter password:"
  pass = gets.chomp
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
else
  puts "invalid entry" # if the user didnt enter login nor register
end
