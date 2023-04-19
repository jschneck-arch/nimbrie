import os
import strutils

const USERS_FILE = os.path.abspath("users.txt")

proc get_user(username: string): option[(string, string, int)] =
  var f: File
  try:
    f = open(USERS_FILE)
    for line in f.lines:
      let fields = line.strip.split(':')
      if fields.len == 3 and fields[0] == username:
        return some((fields[0], fields[1], parseInt(fields[2])))
  except IOError:
    echo "Error: could not read from ", USERS_FILE
  finally:
    f.close()

  none

proc main() =
  echo "Welcome to the system. Please enter the password to continue:"
  let password = readLine(stdin).trim
  if password == "baz":
    echo "Access granted."
    while true:
      echo ""
      echo "Please choose an option:"
      echo "1. Get user information"
      echo "2. List all accounts"
      echo "3. Execute command"
      echo "4. Push script"
      echo "5. Run script"
      echo "6. Create account"
      echo "0. Quit"

      let choice = readLine(stdin).trim
      if choice == "1":
        echo ""
        let username = readLine(stdin).trim
        match get_user(username)
          case some((username, _, privilege)):
            echo "Username: ", username
            echo "Privilege: ", $privilege
          case none:
            echo "User not found"
      elif choice == "2":
        let lines = readFile(USERS_FILE).strip.splitLines
        echo "Username\tPrivilege"
        echo "--------\t---------"
        for line in lines:
          let fields = line.split(':')
          echo fields[0], "\t\t", parseInt(fields[2])
      elif choice == "3":
        echo ""
        let command = readLine(stdin)
        system(command)
      elif choice == "4":
        echo ""
        let filename = readLine(stdin)
        let script = readFile(filename)
        writeFile("script.py", script)
        echo "Script saved as script.py"
      elif choice == "5":
        echo ""
        system("python script.py")
      elif choice == "6":
        echo ""
        let username = readLine(stdin)
        let password = readLine(stdin)
        let privilege = readLine(stdin).parseInt
        let line = username & ":" & password & ":" & $privilege
        let f = open(USERS_FILE, fmAppend)
        f.writeLine(line)
        f.close()
        echo "Account created for ", username, " with privilege level ", $privilege
      elif choice == "0":
        echo "Goodbye."
        break
      else:
        echo "Invalid choice"

main()
