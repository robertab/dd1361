turn = 1
speed = 1
loop = (turn+2*speed)*(10//turn-1)

for i in range(loop):
  loop = (turn+2*speed)*(10//turn-1)
  print(turn, speed, loop)
  speed = speed*11//10+10//turn
  turn = turn+3
