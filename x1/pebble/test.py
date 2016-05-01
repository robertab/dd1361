file1 = open('test1.txt', 'r').readlines()
file2 = open('test2.txt', 'r').readlines()


for i in range(len(file1)):
  if file1[i] != file2[i]:
    print("fel på rad: ", i)


